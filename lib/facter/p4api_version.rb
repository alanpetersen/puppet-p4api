# Fact: p4api_version
#
# Purpose: gets the current p4api version(s)
#
# Resolution:
#   Tests for presence of any p4api installations
#
# Facts:
#   Two facts are created if p4api installations are found:
#      p4api_list - a list of the p4api installations found on the node
#         in the form version => path
#      p4api_maxversion - the highest version found on the node, in the
#         form { :version => version, :path => path }
#
# Caveats:
#   this will only search local filesystems, not mounts
#
# Notes:
#   None

path = ENV['PATH'] + ':/usr/local/bin'
ENV['PATH'] = path

versions = Hash.new

matches = `find / -mount -type d -name p4api-\*`.split()
matches.each do |line|
  base = File.basename(line)
  version = base.split('-')[1]
  versions[version] = line
end

if versions.length > 0 then
  # add the fact for the list of p4api versions
  Facter.add(:p4api_list) do
    setcode do
      versions.inspect
    end
  end
  max_version = versions.keys.sort[-1]
  max_version_hash = {:version => max_version, :path => versions[max_version]}
  Facter.add(:p4api_maxversion) do
    setcode do
      max_version_hash.inspect
    end
  end
end
