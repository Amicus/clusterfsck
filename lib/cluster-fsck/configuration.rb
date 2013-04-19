module ClusterFsck
  class Configuration < Hashie::Mash

    def self.from_yaml(yaml)
      new(YAML.load(yaml))
    end

    def to_yaml
      YAML.dump(to_hash)
    end

  end
end
