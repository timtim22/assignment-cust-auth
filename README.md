# Custom Authentication & Access Control System

A comprehensive Rails application demonstrating advanced authentication patterns, organization-based access control, and age-based participation rules with administrative oversight.

## 📋 Project Overview

This application showcases a sophisticated multi-layered access control system that combines:

- **User Authentication** with age verification and parental consent workflows
- **Organization-Based Access Control** with role-based permissions (admin/member)
- **Age-Appropriate Content Filtering** based on user age groups
- **Administrative Dashboard** for managing parental consent and analytics
- **Real-time Analytics** tracking organization membership and engagement metrics

## 🚀 Quick Setup

### Prerequisites
- Ruby 3.x
- Rails 8.0+
- SQLite3

### Installation Steps

1. **Clone and setup the project:**
   ```bash
   git clone <repository-url>
   cd assignment-cust-auth
   bundle install
   ```

2. **Database setup:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: creates sample data
   ```

3. **Start the server:**
   ```bash
   rails server
   ```

4. **Access the application:**
   - Main app: http://localhost:3000
   - Admin dashboard: http://localhost:3000/admin (for eligible users)

## 🎯 Key Features Implemented

### Phase 1: Foundation & Authentication
✅ **User Registration & Login** (Devise-based)
- Email/password authentication
- Secure session management
- Flash message notifications

✅ **Age Verification System**
- Date of birth collection during registration
- Automatic age calculation and validation
- Age group classification (Child 0-12, Teen 13-17, Adult 18+)

✅ **Parental Consent Workflow**
- Automatic consent requirement for minors (<18)
- Pending consent screen for restricted users
- Admin approval/revocation system

### Phase 2: Organization System
✅ **Organization Management**
- Create organizations with age restrictions
- CRUD operations with validations
- Age-based eligibility filtering

✅ **Membership System**
- Join/leave organizations
- Role-based membership (admin/member)
- Age validation for membership

### Phase 3: Advanced Features
✅ **Authorization & Policies** (Pundit-based)
- Role-based access control
- Organization-scoped permissions
- Graceful error handling

✅ **Content Management System**
- Age-rated content (child/teen/adult)
- Organization-scoped content
- Automatic age-appropriate filtering

### Phase 4: Admin & Analytics
✅ **Admin Dashboard**
- Parental consent management
- Pending request approval workflow
- User access control

✅ **Analytics & Reporting**
- Organization membership metrics
- Age demographic tracking
- Content distribution analysis
- Historical data trends

## 🎮 Demo Walkthrough

### 1. Basic User Flow
1. **Register** with different ages to see various flows:
   - Adult (18+): Full access immediately
   - Minor (<18): Redirected to parental consent screen

2. **Browse Organizations** and test age restrictions:
   - Only see organizations matching your age range
   - Join organizations as member or admin

3. **Content System**:
   - Create age-appropriate content
   - View filtered content based on your age group

### 2. Admin Features (User ID #1 or organization admins)
1. **Access Admin Dashboard** via red button on homepage
2. **Manage Parental Consent**:
   - View pending minor registrations
   - Approve/revoke consent with one click
3. **Analytics Dashboard**:
   - View system-wide metrics
   - Drill down into organization-specific data
   - Track membership and content trends

### 3. Testing Different Age Groups
Create users with different birth dates to test:
- **Child (10 years old)**: Sees only child-rated content
- **Teen (15 years old)**: Sees child + teen content, needs consent
- **Adult (25 years old)**: Full access to all content

## 🏗️ Technical Architecture

### Models & Relationships
- **User**: Authentication, age calculation, consent management
- **Organization**: Age restrictions, membership management
- **UserOrganization**: Join table with roles (member/admin)
- **Content**: Age-rated content with organization scoping
- **OrganizationAnalytic**: Metrics tracking and historical data

### Controllers & Authorization
- **ApplicationController**: Base authentication and consent checks
- **OrganizationsController**: Organization CRUD with Pundit policies
- **ContentsController**: Content management with age filtering
- **Admin::*** Controllers: Administrative interfaces
- **Pundit Policies**: Fine-grained authorization rules

### Key Security Features
- **Multi-layer Access Control**: Authentication → Consent → Membership → Role → Age-appropriate
- **Age Verification**: Server-side validation with reasonable limits
- **Input Validation**: Comprehensive model validations
- **Authorization**: Policy-based access control with Pundit

## 📊 Database Schema

```
users: email, password, date_of_birth, parental_consent, age_group
organizations: name, min_age, max_age
user_organizations: user_id, organization_id, role
contents: title, body, age_rating, organization_id, user_id
organization_analytics: organization_id, metric_name, metric_value, recorded_at
```

## 🔧 Configuration

### Key Dependencies
- **devise**: User authentication
- **pundit**: Authorization policies
- **rails 8.0**: Framework
- **sqlite3**: Database

### Environment Setup
The application runs with default Rails configuration. No additional environment variables required for basic setup.

## 🧪 Testing

Run the test suite:
```bash
rails test
```

Key test coverage includes:
- Model validations and associations
- Policy authorization rules
- Controller actions and redirects
- Age calculation logic
- Content filtering

## 🚀 Deployment Notes

For production deployment:
1. Update database configuration for PostgreSQL/MySQL
2. Set strong secret keys
3. Configure email delivery for notifications
4. Add proper error monitoring
5. Implement background job processing for analytics

## 📁 Project Structure

```
app/
├── controllers/
│   ├── admin/              # Admin dashboard controllers
│   ├── organizations_controller.rb
│   ├── contents_controller.rb
│   └── parental_consent_controller.rb
├── models/
│   ├── user.rb             # Authentication + age logic
│   ├── organization.rb     # Organization management
│   ├── content.rb          # Age-rated content
│   └── organization_analytic.rb
├── policies/               # Pundit authorization
├── views/
│   ├── admin/              # Admin dashboard views
│   ├── organizations/
│   ├── contents/
│   └── users/
└── config/
    └── routes.rb           # Application routing
```

## 💡 Key Innovations

1. **Layered Security Model**: Multiple verification layers ensuring appropriate access
2. **Age-Appropriate Filtering**: Dynamic content filtering based on user age groups  
3. **Real-time Analytics**: Live metrics calculation and historical tracking
4. **Intuitive Admin Interface**: Streamlined consent management workflow
5. **Responsive Authorization**: Context-aware permissions based on roles and age

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- **Rails Architecture**: MVC patterns, RESTful design, Rails conventions
- **Authentication & Authorization**: Devise integration, policy-based access control
- **Database Design**: Associations, validations, migrations
- **User Experience**: Multi-step workflows, conditional interfaces
- **Security Patterns**: Input validation, authorization layers, age verification
- **Analytics Implementation**: Metrics tracking, dashboard creation

---

**Built with ❤️ using Ruby on Rails**
