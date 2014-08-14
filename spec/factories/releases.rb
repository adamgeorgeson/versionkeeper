# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :release do
    date '01/01/2099'
    mysageone '1.0'
    accounts '1.0'
    accounts_extra '1.0'
    payroll '1.0'
    collaborate '1.0'
    help '1.0'
    addons '1.0'
    notes 'Notes'
    status 'UAT'
    release_notes 'Release Notes'
  end

  factory :release_without_status, class: Release do
    date '01/01/2099'
    mysageone '1.0'
    accounts '1.0'
    accounts_extra '1.0'
    payroll '1.0'
    collaborate '1.0'
    help '1.0'
    addons '1.0'
    notes 'Notes'
    status 'UAT'
    release_notes 'Release Notes'
  end

  factory :release_only_date, class: Release do
    date '01/01/2099'
  end

  factory :invalid_release, class: Release do
    date ''
    mysageone '1.0'
    accounts '1.0'
    accounts_extra '1.0'
    payroll '1.0'
    collaborate '1.0'
    help '1.0'
    addons '1.0'
  end
end
