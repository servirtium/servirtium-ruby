# Servirtium Compatibility Suite Runner

The compatibility suite allows us to check this Ruby version of Servirtium against other language implementations. Regular users of Servirtium are unlikely to deploy Servirtium in this configuration. People contributing to Servirtium development will be interested in this.

You'll need to have Docker, Python3 installed in addition to the Ruby 2.6.6 and Bundler/Gems

## Running this from a cloned/checked out directory

```
git clone git@github.com:servirtium/compatibility-suite-runner.git
git clone git@github.com:servirtium/servirtium-ruby.git
cd servirtium-ruby
docker-compose build
python3 ../compatibility-suite-runner/compatibility-suite.py record -p 61417
```

That records 16 interactions with out test suite - you'll need to be online

```
python3 path/to/compatibility-suite-runner/compatibility-suite.py playback -p 61417
```

That replays the 16 records interactions with out test suite - you can be offline and this will still work

### Comparing the output to the reference recording

```
bash path/to/compatibility-suite-runner/compare_recording_with_reference_case.sh .compatibility_suite_recording.md 
```

This script will tell you whether the recoding you just made is the same as the reference recording.

## Running this GitHub without cloning

Note 'record' and 'playback' above.

### Mac & Linux

As above but the above Python3 line should be

```
curl -s https://raw.githubusercontent.com/servirtium/compatibility-suite-runner/main/compatibility-suite.py \
  | python3 /dev/stdin record -p 61417  
```

Repeat the above with 'playback' instead of the 'record'

## Running this without installing Ruby. Bundler, Gems, etc

TODO - Docker way - note that it's slower.