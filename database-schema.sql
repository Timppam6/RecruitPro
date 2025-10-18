-- RecruitPro Database Schema for No-Code Platforms
-- Compatible with PostgreSQL, MySQL, and other relational databases
-- Use this schema when setting up your no-code platform database

-- Users table - Store employer account information
CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    company_id VARCHAR(255),
    plan_tier VARCHAR(20) DEFAULT 'basic' CHECK (plan_tier IN ('basic', 'pro', 'enterprise')),
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    stripe_customer_id VARCHAR(255)
);

-- Companies table - Store company information
CREATE TABLE companies (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    website VARCHAR(255),
    logo_url VARCHAR(500),
    industry VARCHAR(100),
    company_size VARCHAR(20),
    location VARCHAR(255),
    employer_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Job Postings table - Store job opportunities
CREATE TABLE job_postings (
    id VARCHAR(255) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    responsibilities TEXT,
    location VARCHAR(255),
    job_type VARCHAR(50) DEFAULT 'full-time',
    salary_min DECIMAL(10,2),
    salary_max DECIMAL(10,2),
    salary_currency VARCHAR(3) DEFAULT 'USD',
    experience_level VARCHAR(50),
    department VARCHAR(100),
    company_id VARCHAR(255) NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    posted_by VARCHAR(255) NOT NULL REFERENCES users(id),
    share_link VARCHAR(500) UNIQUE,
    application_deadline DATE,
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    application_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Applications table - Store candidate applications
CREATE TABLE applications (
    id VARCHAR(255) PRIMARY KEY,
    job_posting_id VARCHAR(255) NOT NULL REFERENCES job_postings(id) ON DELETE CASCADE,
    candidate_email VARCHAR(255) NOT NULL,
    candidate_first_name VARCHAR(100) NOT NULL,
    candidate_last_name VARCHAR(100) NOT NULL,
    candidate_phone VARCHAR(20),
    resume_url VARCHAR(500),
    cover_letter TEXT,
    linkedin_url VARCHAR(500),
    portfolio_url VARCHAR(500),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'interviewed', 'accepted', 'rejected')),
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    webhook_triggered BOOLEAN DEFAULT false,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5)
);

-- Interviews table - Track interview processes
CREATE TABLE interviews (
    id VARCHAR(255) PRIMARY KEY,
    application_id VARCHAR(255) NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    interviewer_id VARCHAR(255) REFERENCES users(id),
    interview_type VARCHAR(50) DEFAULT 'phone' CHECK (interview_type IN ('phone', 'video', 'in-person', 'technical')),
    scheduled_at TIMESTAMP,
    completed_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no-show')),
    feedback TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Webhook logs table - Track webhook events for n8n integration
CREATE TABLE webhook_logs (
    id VARCHAR(255) PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB,
    response_status INTEGER,
    response_body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed BOOLEAN DEFAULT false
);

-- Payment transactions table - Track subscription payments
CREATE TABLE payment_transactions (
    id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    stripe_payment_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    plan_tier VARCHAR(20),
    billing_period_start DATE,
    billing_period_end DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_company_id ON users(company_id);
CREATE INDEX idx_companies_employer_id ON companies(employer_id);
CREATE INDEX idx_job_postings_company_id ON job_postings(company_id);
CREATE INDEX idx_job_postings_active ON job_postings(is_active) WHERE is_active = true;
CREATE INDEX idx_applications_job_posting_id ON applications(job_posting_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_email ON applications(candidate_email);
CREATE INDEX idx_interviews_application_id ON interviews(application_id);
CREATE INDEX idx_webhook_logs_event_type ON webhook_logs(event_type);
CREATE INDEX idx_webhook_logs_created_at ON webhook_logs(created_at);
CREATE INDEX idx_payment_transactions_user_id ON payment_transactions(user_id);
CREATE INDEX idx_payment_transactions_status ON payment_transactions(status);

-- Create updated_at trigger function (for PostgreSQL)
-- For other databases, you may need to implement this differently
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_job_postings_updated_at BEFORE UPDATE ON job_postings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_applications_updated_at BEFORE UPDATE ON applications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Sample data for testing (optional)
-- Remove this section in production

INSERT INTO users (id, email, password_hash, first_name, last_name, plan_tier) VALUES
('user_demo_001', 'demo@recruitpro.com', '$2b$10$demo.hash.for.testing', 'John', 'Doe', 'pro');

INSERT INTO companies (id, name, description, employer_id) VALUES
('company_demo_001', 'TechCorp Inc.', 'Leading technology company focused on innovation', 'user_demo_001');

INSERT INTO job_postings (id, title, description, location, company_id, posted_by, share_link) VALUES
('job_demo_001', 'Senior Software Engineer', 'We are looking for a senior software engineer to join our team...', 'San Francisco, CA', 'company_demo_001', 'user_demo_001', 'https://recruitpro.com/jobs/senior-software-engineer-001');

-- RLS (Row Level Security) policies for PostgreSQL
-- Uncomment and modify these for production use

-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- CREATE POLICY "Users can view own data" ON users FOR SELECT USING (auth.uid() = id);
-- CREATE POLICY "Users can view own company" ON companies FOR SELECT USING (employer_id = auth.uid());
-- CREATE POLICY "Users can view company job postings" ON job_postings FOR SELECT USING (company_id IN (SELECT id FROM companies WHERE employer_id = auth.uid()));

-- Comments for no-code platform setup:
-- 1. Use this schema when connecting your no-code platform to a PostgreSQL database
-- 2. For Bubble.io: Create data types matching these table structures
-- 3. For Adalo: Create collections with these field definitions
-- 4. For Webflow: Use this as reference for your data architecture
-- 5. Ensure proper foreign key relationships are maintained in your no-code platform
