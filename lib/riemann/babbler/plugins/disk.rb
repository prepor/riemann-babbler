class Riemann::Babbler::Disk
  include Riemann::Babbler

  def plugin
    options.plugins.disk
  end

  def disk
    disk = {}
    `df -P`.split(/\n/).each do |r|
      f = r.split(/\s+/)
      next unless f[0] =~ /^\//
      next if f[0] == 'Filesystem'
      x = f[4].to_f/100
      disk.merge!({f[5] => x})
    end
    return disk
  end

  def tick
    disk.each do |point, free|
      report({
        :service => plugin.service + " on #{point}",
        :state => state(free),
        :metric => free
      })
    end
  end

end

Riemann::Babbler::Disk.run
