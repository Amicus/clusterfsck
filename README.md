# Cluster::Fsck

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'cluster-fsck'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cluster-fsck


### setup your credential file
If you are not on an EC2 instance then you should setup your ~/.cluster-fsck file with the followng yaml:

```yaml
:access_key_id: access_key
:secret_access_key: secret_key
```

If that's not present it will also look for ENV variables as below.  Both must be defined to be used:

```bash
  ENV['AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY']
```

If neither of those is present it will also look for a ~/.fog file with the following syntax

```yaml
:default:
  :aws_access_key_id: access_key
  :aws_secret_access_key: secret_key
```

Otherwise, it expects you to be on an EC2 instance and not have to setup credentials.


## Usage

### From Code

```ruby
reader = ClusterFsck::Reader.new(:stripe)
reader.read[:api_key] # loads config_bucket/cluster_fsck_env/stripe and returns the api_key from the hash
```

#### From the command line
The first time you run ClusterFsck through it's CLI, it will pull its
configuration from one of a few locations if you configured it manually,
or prompt you to accept a generated bucket name (or enter your own) and to 
provide AWS keys, and then store the configuration for you in `~/.clusterfsck`.

The other locations it checks for its config are `/usr/clusterfsck` and in 
the local directory where it was run from, `./.clusterfsck`, checking usr, then 
home, then local.  It also looks for S3 keys in a `~/.fog` file and for any or all
of its config keys in environment variables.  It will also check if the
bucket exists and offer to create it if it does not.

See help on bin/clusterfsck

The ClusterFsck::Reader instance will automatically load the configuration for
the environment stored in the CLUSTER_FSCK_ENV environment variable on the host.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
