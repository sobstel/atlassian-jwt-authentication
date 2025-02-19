# frozen_string_literal: true

module AtlassianJwtAuthentication
  MAJOR_VERSION = "0"
  MINOR_VERSION = "9"
  PATCH_VERSION = "2"

  # rubygems don't support semantic versioning - https://github.com/rubygems/rubygems/issues/592, using GITHUB_RUN_NUMBER to represent build number
  # going to release pre versions automatically
  BUILD_NUMBER = ENV["GITHUB_RUN_NUMBER"] && ".pre#{ENV["GITHUB_RUN_NUMBER"]}" || ""

  VERSION =
    (
      [
        MAJOR_VERSION,
        MINOR_VERSION,
        PATCH_VERSION
      ].join(".") + BUILD_NUMBER
    ).freeze
end
