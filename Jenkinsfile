#!/usr/bin/env groovy

library("govuk@add-support-for-rcov-and-junit")

node("postgresql-9.3") {
  govuk.buildProject(
    overrideTestTask: {
      stage("Run custom tests") {
        govuk.runRakeTask("ci:setup:rspec default")
      }
    },
    brakeman: true,
  )
}
