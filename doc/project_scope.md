# Project: Custom Authentication & Access Control

## Overview

This Rails application adds robust, organization-scoped authentication and age-based participation rules. It leverages proven gems and Rails conventions to keep implementation smooth and maintainable.

## Goals

* Implement user authentication and registration with age verification.
* Model and enforce organization-based membership and role permissions.
* Provide a parental-consent workflow for underage users.
* Expose an admin dashboard for membership and consent management.
* Create organization analytics and reporting system.
* Implement age-group specific participation spaces and content filtering.

## Dependencies

* **Rails 7.x**
* **Devise** for authentication
* **Rolify** (or built‑in roles) for user roles within organizations
* **Pundit** for policy-based authorization
* **ActiveAdmin** (optional) for quickly building admin interfaces
* **Chartkick** (optional) for analytics dashboards

## Data Models

1. **User**

   * Devise-managed (`email`, `password`)
   * Fields: `date_of_birth:date`, `parental_consent:boolean`, `age_group:string`
2. **Organization**

   * Attributes: `name:string`, `min_age:integer`, `max_age:integer`, metadata as needed
3. **UserOrganization** (join table)

   * `user_id:bigint`, `organization_id:bigint`, `role:string`
   * Manages membership and role assignments
4. **ParticipationRule**

   * `organization_id:bigint`, `age_group:string`, `allowed_actions:text`
   * Stores age-group specific participation rules
5. **Content**

   * `title:string`, `body:text`, `age_rating:string`, `organization_id:bigint`
   * Age-appropriate content system
6. **OrganizationAnalytic**

   * `organization_id:bigint`, `metric_name:string`, `metric_value:decimal`, `recorded_at:datetime`
   * For tracking membership stats, engagement metrics, etc.

## Controllers & Routes

* **Devise** handles `users/registrations` and `users/sessions` routes
* **OrganizationsController** (`index`, `show`, `new`, `create`)
* **MembershipsController** (nested under organizations)

  * `create` (join/request), `update` (change role), `destroy` (leave)
* **AgeVerificationsController** (or integrate into `RegistrationsController`)

  * Display DOB form, trigger parental-consent flow
* **AnalyticsController** (nested under organizations)

  * `index` (dashboard), `show` (specific metrics)
* **ContentController** (nested under organizations)

  * Age-filtered content management

## Authorization & Policies

* Include Pundit in `ApplicationController`:

  ```ruby
  include Pundit
  before_action :authenticate_user!
  after_action  :verify_authorized, except: :index
  ```
* Define policy classes for each resource (e.g., `OrganizationPolicy`, `MembershipPolicy`)
* Enforce role checks (`:member`, `:admin`) in policies
* Add age-group specific authorization in policies

## Workflows

1. **User Sign-up & Age Check**

   * On registration, capture DOB and calculate age_group
   * If under threshold, mark `parental_consent: false` and show pending screen
2. **Parental Consent**

   * Underage users upload signed consent or wait for admin approval
   * Admin toggles `parental_consent` to grant access
3. **Organization Membership**

   * Users request/join orgs; admins assign roles via dashboard
   * Policies prevent non-members from accessing org resources
   * Age-based participation rules filter available actions
4. **Age-Group Specific Participation**

   * Content filtering based on age ratings
   * Different participation spaces for different age groups
   * Age-appropriate features and restrictions
5. **Admin Dashboard**

   * ActiveAdmin or custom `/admin` namespace
   * Views for: member lists, pending consents, role assignments, analytics
   * Organization analytics: membership stats, age demographics, engagement metrics

## Analytics & Reporting Features

* **Membership Analytics**
  * Total members by age group
  * Membership growth over time
  * Role distribution within organization
* **Engagement Metrics**
  * Participation rates by age group
  * Content consumption patterns
  * User retention statistics
* **Age Demographics**
  * Age distribution visualization
  * Parental consent approval rates
  * Age-group specific activity levels

## Testing Strategy

* **Model specs** for validations, associations, and age logic
* **Policy specs** ensuring only authorized roles can perform actions
* **Feature specs** (Capybara) covering:

  * Registration with over/under-age flows
  * Joining and managing organization membership
  * Admin approving parental consent
  * Age-group specific content access
  * Analytics dashboard functionality

## Directory Structure

```
app/
├─ controllers/
│  ├─ admin/            # Admin dashboard controllers
│  ├─ organizations_controller.rb
│  ├─ memberships_controller.rb
│  ├─ age_verifications_controller.rb
│  ├─ analytics_controller.rb
│  └─ content_controller.rb
├─ models/
│  ├─ user.rb
│  ├─ organization.rb
│  ├─ user_organization.rb
│  ├─ participation_rule.rb
│  ├─ content.rb
│  └─ organization_analytic.rb
├─ policies/
│  ├─ organization_policy.rb
│  ├─ membership_policy.rb
│  └─ content_policy.rb
├─ views/
│  ├─ organizations/
│  ├─ memberships/
│  ├─ age_verifications/
│  ├─ analytics/
│  └─ content/
└─ config/
   └─ initializers/devise.rb
```

---

> **Cursor IDE Instructions:**
> Use this `project.md` as the single source of truth for project structure, dependencies, and workflows. When generating code or suggestions, align with the outlined models, controllers, policies, and testing strategy above.


Key Simplifications to Avoid Over-Engineering:
No file uploads - Parental consent is just admin approval
Simple age groups - Just "child", "teen", "adult"
Basic analytics - Just membership counts, no complex metrics
Minimal UI - Focus on functionality, not styling
No email notifications - Keep it simple
No complex participation rules - Just age-based access