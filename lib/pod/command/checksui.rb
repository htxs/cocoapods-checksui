# The CocoaPods check-sui command.

# The CocoaPods namespace
module Pod
  class Command
    class CheckSui < Command
      self.summary = <<-SUMMARY
          Displays which Pods would be changed by running `pod install`
      SUMMARY

      self.description = <<-DESC
          Compares the Pod lockfile with the podfile and shows
          any differences for commit or tag. In non-verbose mode, 
          '~' indicates an existing Pod will be updated to the version specified in Podfile.lock.
      DESC

      self.arguments = []

      def self.options
        [
            ['--verbose', 'Show change details.']
        ].concat(super)
      end

      def initialize(argv)
        @check_command_verbose = argv.flag?('verbose')
        super
      end

      def run
        unless config.lockfile
          raise Informative, 'Missing Podfile.lock!'
        end

        results = find_differences(config)
        has_same_manifests = check_manifests(config)
        print_results(results, has_same_manifests)
      end

      def check_manifests(config)
        # Bail if the first time
        return true unless config.sandbox.manifest

        root_lockfile = config.lockfile.defined_in_file
        pods_manifest = config.sandbox.manifest_path

        File.read(root_lockfile) == File.read(pods_manifest)
      end

      def find_differences(config)
        sui_pods = {}
        config.podfile.dependencies.each do |dependency|
          if dependency.external? &&
              (dependency.external_source[:branch] != nil || dependency.external_source[:tag] != nil || dependency.external_source[:commit] != nil)
            sui_pods[dependency.name] = dependency.external_source.clone
          end
        end
        sui_pod_names = sui_pods.keys

        sui_pod_names.sort.uniq.map do |spec_name|
          locked_checkout = config.lockfile.checkout_options_for_pod_named(spec_name)
          next if locked_checkout.nil?

          locked_checkout_commit = locked_checkout[:commit]
          locked_checkout_tag = locked_checkout[:tag]
          development_tag = sui_pods[spec_name][:tag]
          development_commit = sui_pods[spec_name][:commit]

          if development_tag != nil && locked_checkout_tag != nil && development_tag != locked_checkout_tag
            # check tag
            changed_result(spec_name, "locked_tag: #{locked_checkout_tag}", "development_tag: #{development_tag}")
          elsif development_commit != nil && locked_checkout_commit != nil && development_commit != locked_checkout_commit
            # check local commit
            changed_result(spec_name, "locked_commit: #{locked_checkout_commit}", "development_commit: #{development_commit}")
          elsif locked_checkout_commit != nil
            # check remote commit
            remote_commit = get_latest_remote_commit(sui_pods[spec_name])
            if remote_commit != locked_checkout_commit
              changed_result(spec_name, "locked_commit: #{locked_checkout_commit}", "remote_commit: #{remote_commit}")
            end
          end
        end.compact
      end

      def get_latest_remote_commit(external_source)
        if @check_command_verbose
          UI.puts "Fetch remote commit for #{external_source[:git]} on branch: #{external_source[:branch]}"
        end

        command = "git ls-remote #{external_source[:git]} #{external_source[:branch]} | awk '{print$1}'"
        return (`#{command}` || '').strip
      end

      def changed_result(spec_name, manifest_version, locked_version)
        if @check_command_verbose
          "#{spec_name} #{manifest_version} -> #{locked_version}"
        else
          "~#{spec_name}"
        end
      end

      def print_results(results, same_manifests)
        return UI.puts "The Podfile's dependencies are satisfied" if results.empty? && same_manifests

        unless same_manifests
          raise Informative, 'The Podfile.lock does not match the Pods/Manifest.lock.'
        end

        if @check_command_verbose
          UI.puts results.join("\n")
        else
          UI.puts results.join(', ')
        end

        raise Informative, "`pod install` will install #{results.length} Pod#{'s' if results.length > 1}."
      end
    end
  end
end
