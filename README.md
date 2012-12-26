# Cluster::Fuck

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'cluster-fuck'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cluster-fuck


### setup your credential file
If you are not on an EC2 instance then you should setup your ~/.cluster-fuck file with the followng yaml:

```yaml
:access_key_id: access_key
:secret_access_key: secret_key
```

It will also look for a ~/.fog file with the following syntax

```yaml
:default:
  :aws_access_key_id: access_key
  :aws_secret_access_key: secret_key
```

Otherwise, it expects you to be on an EC2 instance and not have to setup credentials.


## Usage

```ruby
reader = ClusterFuck::Reader.new
reader[:stripe][:api_key] loads "config_bucket/amicus_env/stripe and returns the api_key from the hash
```
The ClusterFuck::Reader instance will automatically load the configuration for 
the environment stored in the AMICUS_ENV environment variable on the host.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
