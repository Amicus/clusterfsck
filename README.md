# ClusterFsck

ClusterFsck manages configuration across any number of projects or servers by reading and writing simple YAML stored on Amazon S3. It also allows overriding these configs locally through files (e.g. so your tests don't need network).

(not tested on windows, patches accepted)

## Installation

Add this line to your application's Gemfile:

    gem 'clusterfsck'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clusterfsck


## Configuration & Setup

#### From the command line
Type `clusterfsck init` to initiate ClusterFsck's setup assistant, or manually create a YAML file called `.clusterfsck` in your user's home directory or the root of your project with a `cluster_fsck_bucket` key set to the name of the bucket you want to use to store configuration. ClusterFsck will also need your aws credentials. Store those in the .clusterfsck file or pass those in using environment variables. In production, we recommend you use [IAM role-based access](http://aws.typepad.com/aws/2012/06/iam-roles-for-ec2-instances-simplified-secure-access-to-aws-service-apis-from-ec2.html).

Now, you can run `clusterfsck new <config name>` to create your first clusterfsck managed configuration.  It will automatically call the clusterfsck edit command for you. Future edits should be done with `clusterfsck edit <config name>`, using the editor defined in `$EDITOR`.  It raises an error if no config name is provided. See Usage below for accessing the config from code.

Like Rails, clusterfsck defaults `CLUSTER_FSCK_ENV` to `development` but the environment can be set to any string. There is one 'special' environment `shared` that is where default configs are stored. If a config does not exist in the environment you request it, then clusterfsck will look in the shared environment and only if it does *not* exist, will it error.

For example:
`$> clusterfsck edit shared myconfig`
edit... edit... edit...
```ruby
ENV['CLUSTERFSCK_ENV'] = 'production'
ClusterFsck::Reader.new(:myconfig).read #will be anything you set in the shared myconfig
```

The command line client also provides several additional commands, including list, which lists config files in the current or specified `list`, and `override` which will copy down the files for the environment, and use those local files in place of the S3 based configuration.  You can use this option to develop locally without internet access. In general, the command line uses the default environment, but allows specifying an environment as the first argument.

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

Please help us improve this documentation. Pull requests or feedback are very appreciated!

## Usage

### setup your credential file
You should probably run automated setup as a first step, but ClusterFsck checks for all its settings first in
ENV variables as below.  For AWS keys, both access and secret keys must be defined or neither will be used (which is awesome in production, use IAM roles!):

You may also define ClusterFsck's configuration using environment variables:
```bash
  ENV['CLUSTER_FSCK_BUCKET']
  ENV['CLUSTER_FSCK_ENV']
  ENV['AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY']
```

After checking ENV variables, clusterfsck will look in './.clusterfsck','/usr/clusterfsck', or '~/.clusterfsck'] for the following yaml.

```yaml
:aws_access_key_id: access_key
:aws_secret_access_key: secret_key
:cluster_fsck_bucket: bucket_name
:cluster_fsck_env: environment //probably development, production, staging or shared
```

If you do not define AWS in the environment variables, or the .clusterfsck file, then clusterfsck will check in a ~/.fog file for something that looks like this:

```yaml
:default:
  :aws_access_key_id: access_key
  :aws_secret_access_key: secret_key
```

### From Code

```ruby
reader = ClusterFsck::Reader.new(:stripe)
reader.read[:api_key] # loads config_bucket/cluster_fsck_env/stripe and returns the api_key from the hash
```

The ClusterFsck::Reader instance will load the configuration for the environment stored in the first defined CLUSTER_FSCK_ENV lookup location as described above.

ClusterFsck is currently Ruby only, but any links or pull requests for other language implementations of the Reader module are welcome, and should be able to cooperate happily with the Ruby version.

This code is MIT licensed, see LICENSE.txt file.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
