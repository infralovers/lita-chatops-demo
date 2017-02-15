require 'jenkins_api_client'
require 'open-uri'

module Lita
  module Handlers
    class ChatopsDemo < Handler
      config :jenkins_url, type: String, default: 'http://localhost:8080/'

      http.post '/chatops/deployer/jenkins', :receive

      route(/^deploy (\w+)\s+(.+)$/,
            :handle_deploy!,
            command: true,
            help: { '`deploy <application> <version>`' => '*applications*: frontend, backend' })

      def handle_deploy!(response)
        start_jenkins_job_with_artifact_version("chatops-demo-#{response.matches[0][0]}-deployment", response.matches[0][1], response)
      end

      def receive(request, response)
        data = GitlabHelper.parse_data(request)

        send_attachment_to_room(
          data[:object_attributes][:channel],
          Lita::Adapters::Slack::Attachment.new(
            data[:object_attributes][:message].to_s,
            color: type_to_color(data[:object_attributes][:build_status].to_s)
          )
        )

        response.write('ok')
      end

      private

      def start_jenkins_job_with_artifact_version(job_name, artifact_version, response)
        jenkins_client.job.build(job_name, 'build_version' => artifact_version, 'triggered_by' => response.user.metadata['mention_name'])
        send_jenkins_job_trigger_message(response, "#{job_name} #{artifact_version}\nTriggered")
      end

      def send_jenkins_job_trigger_message(response, message)
        reply_with_attachment(
          response,
          Lita::Adapters::Slack::Attachment.new(
            message,
            color: type_to_color('INFO')
          )
        )
      end

      def send_attachment_to_room(room, attachment)
        target = Lita::Room.find_by_name(room)
        robot.chat_service.send_attachment(target, attachment)
      end

      def reply_with_attachment(response, attachment)
        target = response.message.source.room_object || response.message.source.user
        robot.chat_service.send_attachment(target, attachment)
      end

      def type_to_color(type)
        case type
        when 'SUCCESS'
          '#00ae65'
        when 'WARNING'
          '#feed00'
        when 'ERROR'
          '#e44429'
        else
          '#00b0ea'
        end
      end

      def jenkins_client
        @jenkins_client ||= JenkinsApi::Client.new(server_url: config.jenkins_url)
      end
    end
    Lita.register_handler(ChatopsDemo)
  end
end
