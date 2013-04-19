# ClusterFsck

ClusterFsck manages configurable settings and sensitive login information across any number of separate or related projects by reading writing simple values or arrays/hashes of data to and from YAML files stored on Amazon S3. It also allows centrally overriding or changing these on a per environment basis.

## Installation

Add this line to your application's Gemfile:

    gem 'clusterfsck'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clusterfsck


## Configuration & Setup

#### From the command line
Type `clusterfsck init` to initiate ClusterFsck's setup assistant, or manually create a YAML file called `.clusterfsck` in your home or the root of your project directory with a `CLUSTER_FSCK_BUCKET` key set to the name of a bucket you have or will create to store configuration.  It also needs AWS keys, but if you already use AWS and have a ~/.fog file with credentials in it, it will find those, or they can be stored in the .clusterfsck file or in environment variables.

Assuming you've completed the setup, you can run `clusterfsck new <project name>` to create your first clusterfsck managed configuration.  It will automatically call the edit command for you once it's created, and future edits will be done with `clusterfsck edit <project name>`, using the editor defined in `$EDITOR` (not tested on windows, pull requests welcome).  It raises an error if no project name is provided.  See Usage guideline below for accessing the stored configuration from your code.

By default it sets the `CLUSTER_FSCK_ENV` to `development`, much like Rails, but you can set to anything.  If your system is not yet in production, or you have many settings the same between development and staging/production, you may wish to change the default `CLUSTER_FSCK_ENV` to `shared`.  A `ClusterFsck::Reader` instance will look in it's environment's project file first for any key, and if not found, it will check in the shared environments's projects.

The command line client also provides several additional commands, including list, which lists config files in the current or specified `list`, and `override` which will copy down the files for the current environment, and use those local files (including any edits you make locally) in place of the S3 based configuration.  You can also use this option to develop locally without internet access.

You can run `clusterfsck --help` to get usage, currently that outputs as follows:

`$> clusterfsck --help`
```bash
  NAME:

    clusterfsck

  DESCRIPTION:

    Filebased S3 Cofiguration Kontrol for Clusters, by Amicus

  COMMANDS:

    edit                 Bring up the YAML for key specified in the current CLUSTER_FSCK_ENV or specified CLUSTER_FSCK_ENV in your $editor
    environments         List all environments defined in the bucket ClusterFsck is setup using
    help                 Display global or [command] help documentation.
    init                 Create ClusterFsck configuration file - called automatically from other commands if no config found.
    list                 List all keys in the current or specified CLUSTER_FSCK_ENV
    new                  Create a yaml file for your current CLUSTER_FSCK_ENV or specified CLUSTER_FSCK_ENV
    override             Will copy down the remote config and create a directory clusterfsck/:CLUSTER_FSCK_ENV/:key that will be used by default over the remote

  GLOBAL OPTIONS:

    -h, --help
        Display help documentation

    -v, --version
        Display version information

    -t, --trace
        Display backtrace when an error occurs
```

Please help us improve this documentation with pull requests or feedback on where it needs work!

## Usage

### setup your credential file
You should probably run automated setup as a first step, but ClusterFsck checks for all it's settings first in
ENV variables as below.  For AWS keys, both access and secret keys must be defined or neither will be used:

```bash
  ENV['AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY']
```

You may also define ClusterFsck's configuration this way:
```bash
  ENV['CLUSTER_FSCK_BUCKET']
  ENV['CLUSTER_FSCK_ENV']
```
You don't need AWS keys defined running on EC2, but if not on EC2, then after checking for AWS keys in ENV variables, it will look for a `~/.fog` file with the following syntax

```yaml
:default:
  :aws_access_key_id: access_key
  :aws_secret_access_key: secret_key
```

After checking ENV variables and the `~/.fog` file, the only remaining option is to be defined in the `~/.clusterfsck` file with the followng yaml:

```yaml
:AWS_ACCESS_KEY_ID: access_key
:AWS_SECRET_ACCESS_KEY: secret_key
:CLUSTER_FSCK_BUCKET: bucket_name
:CLUSTER_FSCK_ENV: environment //probably development, production, staging or shared
```

### From Code

```ruby
reader = ClusterFsck::Reader.new(:stripe)
reader.read[:api_key] # loads config_bucket/cluster_fsck_env/stripe and returns the api_key from the hash
```

The ClusterFsck::Reader instance will automatically load the configuration for
the environment stored in the CLUSTER_FSCK_ENV environment variable on the host.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
