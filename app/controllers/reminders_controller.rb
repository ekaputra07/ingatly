class RemindersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_instance, only: [:show, :edit, :update, :destroy, :verify]

    def index
        @reminders = Reminder.where(user: current_user).order(created_at: :desc)
    end

    def new
        # reminders_count = Reminder.where(user: current_user).count
        # if reminders_count < 2
        #     @reminder = Reminder.new
        # else
        #     redirect_to reminders_path, alert: "Jumlah pengingat dibatasi maksimal 2 buah untuk Ingatly Free."
        # end
        @reminder = Reminder.new

    end

    def create
        @reminder = Reminder.new(reminder_params)
        @reminder.user = current_user

        if @reminder.save
            redirect_to reminders_path, notice: "Pengingat \"#{@reminder.type_info[:name]} (#{@reminder.identifier})\" di buat."
        else
            render :new
        end
    end

    def edit
    end

    def update
        changed = reminder_params[:identifier] != @reminder.identifier

        if @reminder.update(reminder_params)
            if changed
                @reminder.update_attribute(:verified, false)
                redirect_to reminders_path, notice: "Pengingat \"#{@reminder.type_info[:name]} (#{@reminder.identifier})\" telah diperbarui, silahkan lakukkan verifikasi."
            else
                redirect_to reminders_path, notice: "Pengingat \"#{@reminder.type_info[:name]} (#{@reminder.identifier})\" telah disimpan."
            end
        else
            render :edit
        end
    end

    def destroy
        @reminder.destroy
        redirect_to reminders_path, notice: "Pengingat \"#{@reminder.type_info[:name]} (#{@reminder.identifier})\" telah dihapus."
    end

    def verify
        if request.get?
            if params[:send] == 'true'
                # send verification
                if @reminder.reminder_type == 0 #email
                    ReminderMailer.send_verification_token(@reminder).deliver_later
                    notice = "Kode konfirmasi telah di-email ke <strong>#{@reminder.identifier}</strong>."
                end
                if @reminder.reminder_type == 1 #sms
                    SendVerifyTokenJob.perform_later(@reminder)
                    notice = "Kode konfirmasi telah dikirim ke <strong>#{@reminder.identifier}</strong> melalui SMS."
                end
                redirect_to verify_reminder_path(@reminder), notice: notice
            end
        elsif request.post?
            if @reminder.valid_token? params[:verification_token]
                @reminder.update_attribute(:verified, true)
                redirect_to reminders_path, notice: "Pengingat \"#{@reminder.type_info[:name]} (#{@reminder.identifier})\" telah diverifikasi."
            else
                redirect_to verify_reminder_path(@reminder), alert: "Kode verifikasi salah."
            end

        end
    end

    private

        def set_instance
            @reminder = Reminder.find_by(id: params[:id], user: current_user)
        end

        def reminder_params
            params.require(:reminder).permit(:reminder_type, :identifier)
        end
end
