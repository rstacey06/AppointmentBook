class Appointment < ActiveRecord::Base
    belongs_to :location
    belongs_to :user
    belongs_to :client

    accepts_nested_attributes_for :client
    accepts_nested_attributes_for :location

    def start_time
      self.appointment_time
    end

    def end_time
      appointment_time + duration.seconds
    end

    def client_name
      client.name
    end

    def location_name
      location.nickname if location
    end

    # parse form methods

    def client_attributes=(attr)
      if attr[:name] != ""
        self.client = self.user.clients.find_or_create_by(attr)
      end
    end

    def location_attributes=(attr)
      if attr[:nickname] != ""
        location = self.user.locations.find_or_create_by(attr)
        self.location = location
      end
    end

    #custom setter called upon receving a hash(mass assignment) from the appointment#create actions, also accepts a time object for testing
    #when called on a hash the parse_datetime method is called on the hash to produce a datetime object that can be save in DB 
    def appointment_time=(time)
      if time.is_a?(Hash)
        self[:appointment_time] = parse_datetime(time)
      else
        self[:appointment_time] = time
      end
    end

    def parse_date(string)
      array = string.split("/")
      first_item = array.pop
      array.unshift(first_item).join("-")
    end

    def parse_datetime(hash)
      if hash["date"].match(/\d{2}\/\d{2}\/\d{4}/)
        Time.zone.parse("#{parse_date(hash["date"])} #{hash["hour"]}:#{hash["min"]}")
      end
    end

    def duration=(duration)
      if duration.is_a?(Hash)
        self[:duration] = parse_duration(duration)
      else
        self[:duration] = duration
      end
    end

    def parse_duration(hash)
      hash["hour"].to_i + hash["min"].to_i
    end

    # Validations

    validates :duration, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :appointment_time, presence: { message: "must be a valid date" }
    validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
    validates :client_id, presence: true

    validate :time_still_valid

    def time_still_valid
      AppointmentTimeValidator.new(self).validate
    end

    include ActiveModel::Validations

    class AppointmentTimeValidator
      def initialize(appointment)
        @appointment = appointment
        @user = appointment.user
      end

      def validate
        if @appointment.appointment_time
          # selects the user's appointments from yesterday, today and tomorrow
          appointments = @user.appointments.select { |a| a.appointment_time.midnight == @appointment.appointment_time.midnight || a.appointment_time.midnight == @appointment.appointment_time - 1.day || a.appointment_time.midnight == @appointment.appointment_time + 1.day }
          # makes sure that current appointments don't overlap and checks if an existing appointment is still in progress when the new appointment is set to start
          # then checks if the new appointment would still be going on when an existing appointment is set to start
          appointments.each do |appointment|
            if @appointment != appointment
              if appointment.appointment_time <= @appointment.appointment_time && @appointment.appointment_time <= appointment.end_time || @appointment.appointment_time <= appointment.appointment_time && appointment.appointment_time <= @appointment.end_time
                @appointment.errors.add(:appointment_time, "is not available.")
              end
            end
          end
        end
      end
    end

    validate do |appointment|
      AppointmentTimeValidator.new(appointment).validate
    end

  end
