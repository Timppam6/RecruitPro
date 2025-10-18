# RecruitPro - Professional Job Recruitment Platform

A modern, dark-themed job recruitment web application built for no-code/low-code platforms with functional authentication, database integration, and payment processing.

![RecruitPro Screenshot](https://via.placeholder.com/800x400/000000/ffffff?text=RecruitPro+Dashboard)

## 🌟 Features

### For Employers
- **Secure Authentication** - Email/password login with session management
- **Company Management** - Create and manage company profiles
- **Job Posting** - Create, edit, and manage job listings with unique shareable links
- **Application Management** - Review and manage candidate applications
- **Analytics Dashboard** - Track applications, interviews, and hiring metrics
- **Payment Integration** - Three-tier subscription plans with Stripe

### For Candidates
- **Job Discovery** - Browse and search job opportunities
- **Easy Application** - Simple, mobile-friendly application forms
- **File Upload** - Resume/CV upload with drag-and-drop support
- **Application Tracking** - Success confirmations and next steps

### Technical Features
- **Dark Mode Design** - Professional dark theme with orange accent elements
- **Responsive Layout** - Works perfectly on desktop, tablet, and mobile
- **Real-time Updates** - Live application and payment status updates
- **Webhook Integration** - n8n workflow automation for notifications
- **Database Integration** - PostgreSQL-compatible schema for no-code platforms

## 🎨 Design System

### Color Palette
- **Primary Background**: `#000000` (Deep Black)
- **Surface Background**: `#0a0a0a` (Dark Gray)
- **Primary Text**: `#ffffff` (Pure White)
- **Secondary Text**: `#b3b3b3` (Light Gray)
- **Orange Accent**: `#ff6b35` (Primary Orange)
- **Orange Variants**: `#ff8c42`, `#ff5722`, `#e64a19`

### Orange Accent Elements
- Corner splat decorations for visual interest
- Button hover dots and loading indicators
- Form field accent borders
- Navigation highlights and active states
- Success indicators and feature dots

## 🚀 Quick Start

### 1. Choose Your No-Code Platform

This application is designed to work with popular no-code platforms:

- **Bubble.io** - Full visual development platform
- **Adalo** - Mobile-first no-code platform
- **Webflow** - Professional website builder
- **FlutterFlow** - Cross-platform app development

### 2. Database Setup

#### Option A: PostgreSQL Database
```sql
-- Use the provided database-schema.sql file to create tables
-- Connect your no-code platform to your PostgreSQL instance
```

#### Option B: No-Code Database
- **Bubble.io**: Create data types matching the schema
- **Adalo**: Create collections with corresponding fields
- **Airtable**: Create bases with linked tables

### 3. Authentication Setup

#### Bubble.io
1. Enable "Enable user authentication" in Settings
2. Create login/signup workflows
3. Set up email verification

#### Adalo
1. Enable authentication in app settings
2. Create login/signup screens
3. Configure email templates

### 4. Payment Integration

#### Stripe Setup
1. Create a Stripe account
2. Get your publishable and secret keys
3. Configure webhooks for payment events

#### Platform-Specific Setup
- **Bubble.io**: Use Stripe plugin
- **Adalo**: Configure Stripe component
- **Webflow**: Use custom code or Stripe integration

### 5. Webhook Configuration (n8n)

#### Setup n8n Workflow
1. Install n8n (self-hosted or cloud)
2. Create new workflow with webhook trigger
3. Add email notification nodes
4. Configure error handling

#### Test Webhook
```bash
curl -X POST https://your-n8n-instance.com/webhook/application-received \\
  -H "Content-Type: application/json" \\
  -H "X-RecruitPro-Signature: your_signature" \\
  -d @sample-payload.json
```

## 📁 Project Structure

```
recruitpro-no-code/
├── index.html                 # Landing page
├── login.html                 # Employer login
├── signup.html                # Employer registration
├── dashboard.html             # Employer dashboard
├── job-application.html       # Candidate application form
├── application-success.html   # Application confirmation
├── payment.html               # Payment processing
├── database-schema.sql        # Database schema
├── n8n-webhook-config.json    # Webhook configuration
├── recruitment-app-structure.json # Project overview
└── README.md                  # This file
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file or configure in your no-code platform:

```env
# Database
DATABASE_URL=postgresql://username:password@host:port/database

# Authentication
JWT_SECRET=your-jwt-secret-key
SESSION_TIMEOUT=24h

# Payment (Stripe)
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Email (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Webhooks (n8n)
N8N_WEBHOOK_URL=https://your-n8n.com/webhook/
WEBHOOK_SECRET=your-webhook-secret

# Optional Integrations
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
```

### No-Code Platform Settings

#### Bubble.io Setup
1. **API Settings**:
   - Enable "Expose API" in Settings > API
   - Generate API tokens for external integrations

2. **Database**:
   - Connect to PostgreSQL or use Bubble database
   - Create data types: User, Company, Job_Posting, Application

3. **Workflows**:
   - Create signup/login workflows
   - Set up payment processing workflows
   - Configure email notifications

#### Adalo Setup
1. **Database Collections**:
   - Users (email, password, company)
   - Companies (name, description, owner)
   - Jobs (title, description, company, status)
   - Applications (candidate info, job, status)

2. **Screens**:
   - Login screen with authentication
   - Dashboard with job listings
   - Application form for candidates
   - Payment screens

## 💳 Pricing Plans

### Basic - $60/month
- Up to 5 job postings
- Basic company profile
- Email support
- Standard application forms

### Pro - $200/month (Most Popular)
- Up to 25 job postings
- Enhanced company profile
- Priority email support
- Custom application forms
- Basic analytics

### Enterprise - $500/month
- Unlimited job postings
- Premium company profile
- Phone & email support
- Advanced analytics
- Custom integrations
- API access

## 🔗 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - User registration
- `POST /api/auth/logout` - User logout

### Jobs
- `GET /api/jobs` - List active jobs
- `POST /api/jobs` - Create new job
- `PUT /api/jobs/:id` - Update job
- `DELETE /api/jobs/:id` - Delete job

### Applications
- `GET /api/applications` - List applications
- `POST /api/applications` - Submit application
- `PUT /api/applications/:id` - Update application status

### Companies
- `GET /api/companies/:id` - Get company details
- `PUT /api/companies/:id` - Update company

## 🔔 Webhook Events

### Application Submitted
Triggered when a candidate submits an application.

**Payload:**
```json
{
  "event": "application.submitted",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "application": { ... },
    "job": { ... },
    "company": { ... }
  }
}
```

### Payment Completed
Triggered when an employer completes payment.

### User Registered
Triggered when a new employer registers.

## 📱 Mobile Responsiveness

The application is fully responsive with:
- **Desktop**: Full-featured dashboard and forms
- **Tablet**: Optimized layout with touch-friendly interactions
- **Mobile**: Streamlined interface for on-the-go usage

## 🔒 Security Features

- **Input Validation**: All forms validate input data
- **CSRF Protection**: Cross-site request forgery prevention
- **Rate Limiting**: API rate limiting to prevent abuse
- **Secure Headers**: Security headers for all responses
- **Data Encryption**: Sensitive data encryption at rest

## 🚀 Deployment

### Option 1: Static Hosting (Netlify, Vercel)
1. Upload HTML files to your hosting provider
2. Configure environment variables
3. Set up custom domains and SSL

### Option 2: No-Code Platform Hosting
1. **Bubble.io**: Deploy to bubbleapps.io
2. **Adalo**: Publish to app stores or web
3. **Webflow**: Publish to webflow.io

### Option 3: Self-Hosted
1. Set up a web server (Nginx, Apache)
2. Configure SSL certificates
3. Set up database and environment variables

## 🧪 Testing

### Demo Credentials
- **Email**: demo@recruitpro.com
- **Password**: demo123456

### Test Payment
- **Card**: 4242 4242 4242 4242
- **Expiry**: 12/25
- **CVV**: 123

## 🛠️ Development

### Adding New Features
1. Update the database schema if needed
2. Modify HTML templates for UI changes
3. Update webhook configurations for new events
4. Test across different devices and browsers

### Customization
- **Colors**: Modify CSS custom properties in `:root`
- **Animations**: Adjust keyframes and transition properties
- **Layout**: Update grid and flexbox classes

## 📞 Support

For support and questions:
- **Email**: support@recruitpro.com
- **Documentation**: [Link to docs]
- **Community**: [Link to community forum]

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Tailwind CSS** for the utility-first CSS framework
- **Stripe** for payment processing
- **n8n** for workflow automation
- **No-code community** for inspiration and feedback

---

**Built with ❤️ for modern recruitment**
