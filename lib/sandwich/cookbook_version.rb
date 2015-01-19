require 'chef/cookbook_version'

module Sandwich
  # Chef::CookbookVersion, extended to use simpler file source paths
  # (always uses local files relative to @basedir instead of manifest
  # records)
  class CookbookVersion < Chef::CookbookVersion
    # @param [String] name the cookbook's name
    # @param [String basedir the cookbook's basedir
    def initialize(name, basedir)
      super(name)
      @basedir = basedir
    end

    # Determines the absolute source filename on disk for various file
    # resources from their relative path
    #
    # @param [Chef::Node] node the node object, ignored
    # @param [Symbol] segment the segment of the current resource, ignored
    # @param [String] filename the source file path
    # @param [String] current_filepath the target file path, ignored
    # @return [String] the preferred source filename
    def preferred_filename_on_disk_location(node,
                                            segment,
                                            filename,
                                            current_filepath=nil)
      segment_filenames = [
        File.join(segment.to_s, "#{node[:platform]}-#{node[:platform_version]}", filename),
        File.join(segment.to_s, node[:platform], filename),
        File.join(segment.to_s, 'default', filename),
        File.join(segment.to_s, filename),
        File.expand_path(filename, @basedir), # keep absolute paths, convert relative paths into absolute paths
      ]
      segment_filenames.find {|filename| File.exist?(filename) }
    end
  end
end
