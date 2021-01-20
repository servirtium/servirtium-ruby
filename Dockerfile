FROM andrius/alpine-ruby
COPY lib/servirtium/ servirtium/
COPY lib/servirtium.rb /
WORKDIR /
EXPOSE 61417
ENTRYPOINT ["ruby", "servirtium/compatiblity_suite_server.rb"]
# tODO record/playback & port args
