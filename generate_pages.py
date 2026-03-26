import os
import re
import json

base_dir = r"c:\Users\AVN\Downloads\uged"

# Read original index.html
with open(os.path.join(base_dir, "index.html"), "r", encoding="utf-8") as f:
    html_content = f.read()

# Extract head, header (nav), and footer
head_match = re.search(r'(<head>.*?</head>)', html_content, re.DOTALL)
body_start_match = re.search(r'(<body.*?>.*?<header>.*?</header>)', html_content, re.DOTALL)
footer_match = re.search(r'(<footer.*?</footer>.*?</body>\s*</html>)', html_content, re.DOTALL)

if not head_match or not body_start_match or not footer_match:
    print("Could not extract parts from index.html")
    exit(1)

head_template = head_match.group(1)
body_start = body_start_match.group(1)
footer = footer_match.group(1)

# Helper to create page
def create_page(path, title, desc, keywords, h1, content_html, schema_type="LocalBusiness"):
    dir_path = os.path.join(base_dir, path)
    os.makedirs(dir_path, exist_ok=True)
    
    # Update head
    new_head = head_template.replace(
        '<title>U.G. Education Centre | CBSE School in Akbarpur, Kanpur Dehat</title>',
        f'<title>{title} | U.G. Education Centre</title>'
    )
    new_head = re.sub(r'<meta name="description" content=".*?">', f'<meta name="description" content="{desc}">', new_head)
    new_head = re.sub(r'<meta name="keywords" content=".*?">', f'<meta name="keywords" content="{keywords}">', new_head)
    new_head = re.sub(r'<link rel="canonical" href=".*?">', f'<link rel="canonical" href="https://ugeducation.center/{path}/">', new_head)
    new_head = re.sub(r'<meta property="og:title" content=".*?">', f'<meta property="og:title" content="{title}">', new_head)
    new_head = re.sub(r'<meta property="og:description" content=".*?">', f'<meta property="og:description" content="{desc}">', new_head)
    new_head = re.sub(r'<meta property="og:url" content=".*?">', f'<meta property="og:url" content="https://ugeducation.center/{path}/">', new_head)
    
    # Schema
    schema = {
      "@context": "https://schema.org",
      "@type": schema_type,
      "name": "U.G. Education Centre",
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Akbarpur",
        "addressRegion": "Kanpur Dehat",
        "addressCountry": "India"
      },
      "url": f"https://ugeducation.center/{path}/"
    }
    schema_str = json.dumps(schema, indent=2)
    new_head = re.sub(r'<script type="application/ld\+json">.*?</script>', f'<script type="application/ld+json">\n{schema_str}\n</script>', new_head, flags=re.DOTALL)
    
    # Update Nav Links for all pages
    new_body_start = body_start.replace('href="#"', 'href="/"')
    # Let's replace the whole nav block
    nav_links = """
                <nav class="nav-links">
                    <a href="/">HOME</a>
                    <a href="/about-school/">ABOUT</a>
                    <a href="/admissions/">ADMISSIONS</a>
                    <a href="/facilities/">FACILITIES</a>
                    <a href="/blog/">BLOG</a>
                    <a href="/contact/">CONTACT</a>
                </nav>
    """
    new_body_start = re.sub(r'<nav class="nav-links">.*?</nav>', nav_links, new_body_start, flags=re.DOTALL)
    
    # Content structure
    page_html = f"""<!DOCTYPE html>
<html lang="en">
{new_head}
{new_body_start}

    <section class="new-section-container" style="background-color: #000; padding: 120px 40px 60px;">
        <h1 class="section-title" style="color: var(--bright-yellow); font-size: 3rem;">{h1}</h1>
    </section>

    <div class="page-content" style="max-width: 1200px; margin: 0 auto; padding: 40px; color: rgba(255,255,255,0.9); font-family: 'Poppins', sans-serif; line-height: 1.8;">
        {content_html}
    </div>

{footer}
"""
    with open(os.path.join(dir_path, "index.html"), "w", encoding="utf-8") as out_f:
        out_f.write(page_html)

# Pages Data
pages = [
    {
        "path": "admissions",
        "title": "Admissions",
        "desc": "Information on admissions at UG Education Centre in Akbarpur, Kanpur Dehat.",
        "keywords": "admissions UG Education Centre, CBSE school admission, school admission Akbarpur",
        "h1": "Admissions at U.G. Education Centre",
        "content_html": """
            <h2>Welcome to the Admissions Process</h2>
            <p>Choosing the right school for your child is one of the most important decisions you will make. At U.G. Education Centre, recognized as the best school in Kanpur Dehat, we are committed to making the admission process as seamless as possible.</p>
            
            <h3>Admission Criteria</h3>
            <p>We welcome students from all backgrounds. Admission is purely based on merit and the availability of seats. The process involves:</p>
            <ul>
                <li>Submission of the completed application form.</li>
                <li>An interactive session with the student and parents.</li>
                <li>Review of previous academic records.</li>
            </ul>

            <h3>Why Choose Our CBSE School in Akbarpur?</h3>
            <p>Our curriculum is tailored to foster holistic development. From early foundation stages to rigorous middle school academics, our experienced faculty ensures personal attention to every child.</p>
            
            <div style="margin-top: 40px; border-top: 1px solid #333; padding-top: 20px;">
                <h2>Frequently Asked Questions (FAQs)</h2>
                <h3 style="color: var(--bright-yellow);">What is the age criteria for Play Group?</h3>
                <p>Children must be 3 years of age by March 31st of the academic year.</p>
                <h3 style="color: var(--bright-yellow);">Are transport facilities available?</h3>
                <p>Yes, we offer safe and GPS-tracked transport services across Akbarpur and nearby regions in Kanpur Dehat.</p>
            </div>
            
            <div style="margin-top: 40px;">
                <p>Ready to join? <a href="/contact/" style="color: var(--bright-yellow); text-decoration: underline;">Contact us</a> to schedule a campus tour.</p>
            </div>
        """
    },
    {
        "path": "about-school",
        "title": "About Our School",
        "desc": "Learn about the mission, vision, and legacy of U.G. Education Centre in Akbarpur.",
        "keywords": "about UG Education Centre, history of school, CBSE school Akbarpur mission",
        "h1": "About U.G. Education Centre",
        "content_html": """
            <h2>Our Vision and Mission</h2>
            <p>U.G. Education Centre is not just a school; it is a community dedicated to excellence. Our mission is to provide an environment where every student is inspired to learn, challenged to excel, and empowered to succeed.</p>
            
            <h3>A Legacy of Excellence in Kanpur Dehat</h3>
            <p>Through our commitment to traditional values intertwined with modern educational practices, we have established ourselves as the best school in Kanpur Dehat. We focus on ethical growth, innovative learning, and inclusive community building.</p>
            
            <h3>Our Educational Approach</h3>
            <p>Being a premier CBSE school in Akbarpur, our curriculum is strictly adherent to the highest educational standards, integrating critical thinking, arts, and sports into daily learning.</p>
            
            <div style="margin-top: 30px;">
                <p>Learn more about what makes learning here special by exploring our <a href="/facilities/" style="color: var(--bright-yellow); text-decoration: underline;">Campus Facilities</a>.</p>
            </div>
        """
    },
    {
        "path": "facilities",
        "title": "School Facilities",
        "desc": "Explore the outstanding facilities and infrastructure at U.G. Education Centre.",
        "keywords": "school facilities Akbarpur, campus Kanpur Dehat, smart classrooms",
        "h1": "Our World-Class Facilities",
        "content_html": """
            <h2>Empowering Education with Infrastructure</h2>
            <p>A conducive learning environment is crucial for academic success. U.G. Education Centre boasts a state-of-the-art campus designed for safety, comfort, and interactive learning.</p>
            
            <h3>Smart Classrooms</h3>
            <p>Our classrooms are equipped with digital boards and modern teaching aids to make learning engaging and interactive for the students of Kanpur Dehat.</p>

            <h3>Library and Laboratories</h3>
            <p>We believe in practical knowledge. Our science and computer labs are fully equipped to meet the CBSE curriculum standards, while our extensive library houses thousands of books to cultivate a reading habit.</p>

            <h3>Sports and Recreation</h3>
            <p>Physical education is equally important. We have vast playgrounds and skilled coaches for various sports, ensuring the holistic development of our students.</p>
            
            <div style="margin-top: 40px; border-top: 1px solid #333; padding-top: 20px;">
                <h2>Frequently Asked Questions (FAQs)</h2>
                <h3 style="color: var(--bright-yellow);">Do you have a cafeteria?</h3>
                <p>Yes, we have a hygienic cafeteria providing nutritious meals to students.</p>
                <h3 style="color: var(--bright-yellow);">Is the campus secure?</h3>
                <p>Absolutely. The entire campus is under 24/7 CCTV surveillance with trained security personnel.</p>
            </div>
        """
    },
    {
        "path": "cbse-school-in-akbarpur",
        "title": "Top CBSE School in Akbarpur",
        "desc": "Looking for the best CBSE school in Akbarpur? U.G. Education Centre provides holistic education.",
        "keywords": "CBSE school in Akbarpur, top CBSE school Akbarpur, best CBSE school Akbarpur",
        "h1": "Premier CBSE School in Akbarpur",
        "content_html": """
            <h2>Why U.G. Education Centre is the Right Choice</h2>
            <p>If you are searching for a CBSE school in Akbarpur that aligns with global standards while retaining core Indian values, your search ends here. We provide an ecosystem where academic rigor meets extracurricular brilliance.</p>
            
            <h3>The CBSE Advantage</h3>
            <p>The Central Board of Secondary Education (CBSE) curriculum is recognized worldwide. It emphasizes application-based learning. Our faculty ensures that students grasp concepts practically rather than through rote learning.</p>

            <h3>Community Impact</h3>
            <p>By bringing top-tier education to Akbarpur, we aim to uplift the entire community, offering students opportunities that par with those in major metropolitan cities.</p>
            
            <div style="margin-top: 30px;">
                <p>Read about our expert insights on education on our <a href="/blog/" style="color: var(--bright-yellow); text-decoration: underline;">Blog</a>.</p>
            </div>
        """,
        "schema_type": "School"
    },
    {
        "path": "best-school-in-kanpur-dehat",
        "title": "Best School in Kanpur Dehat",
        "desc": "U.G. Education Centre is widely recognized as the best school in Kanpur Dehat, offering unparalleled education.",
        "keywords": "best school in Kanpur Dehat, top schools Kanpur Dehat, Kanpur Dehat education",
        "h1": "The Best School in Kanpur Dehat",
        "content_html": """
            <h2>Setting the Standard for Education in Kanpur Dehat</h2>
            <p>Being named the best school in Kanpur Dehat is an honor we take seriously. It reflects our unwavering commitment to educational excellence, student welfare, and character building.</p>
            
            <h3>Holistic Development Program</h3>
            <p>We focus not only on academics but also on life skills. Our leadership programs, sports academies, and cultural events ensure that students graduate as confident, well-rounded individuals ready to face the world.</p>

            <h3>Parent-Teacher Synergy</h3>
            <p>We maintain an open line of communication with parents, inviting them to be active participants in their child's educational journey through regular PTMs and portal access.</p>
            
            <div style="margin-top: 40px; border-top: 1px solid #333; padding-top: 20px;">
                <h2>Frequently Asked Questions (FAQs)</h2>
                <h3 style="color: var(--bright-yellow);">How does the school define 'best'?</h3>
                <p>By consistently achieving excellent academic results, maintaining top-tier facilities, and fostering a happy, safe environment for every child.</p>
                <h3 style="color: var(--bright-yellow);">What extracurriculars are offered?</h3>
                <p>We offer debate, coding, music, dance, and various outdoor sports.</p>
            </div>
        """,
        "schema_type": "School"
    },
    {
        "path": "contact",
        "title": "Contact Us",
        "desc": "Get in touch with U.G. Education Centre. Address, phone, and email information.",
        "keywords": "contact UG Education Centre, school address Akbarpur, phone number Kanpur Dehat school",
        "h1": "Contact U.G. Education Centre",
        "content_html": """
            <h2>We'd Love to Hear From You</h2>
            <p>Whether you have a question about admissions, facilities, or our curriculum, our team is ready to answer all your questions.</p>
            
            <div style="background: rgba(255,255,255,0.05); padding: 30px; border-radius: 15px; margin-top: 30px;">
                <h3>Our Detailed Contact Information</h3>
                <p><strong>Address:</strong> Gokuldham Society, Shahjadpur, Akbarpur, Kanpur Dehat, Uttar Pradesh, 209101</p>
                <p><strong>Phone:</strong> +91 74994 58100</p>
                <p><strong>Email:</strong> ugeducationcenter@gmail.com</p>
            </div>
            
            <h3 style="margin-top: 40px;">Visit Our Campus</h3>
            <p>Experience the vibrant environment of the best school in Kanpur Dehat firsthand. Book a guided tour by giving us a call today!</p>
            
            <div style="margin-top: 30px;">
                <p>Check out our <a href="/admissions/" style="color: var(--bright-yellow); text-decoration: underline;">Admissions Process</a> before you apply.</p>
            </div>
        """
    }
]

for p in pages:
    create_page(
        p["path"], 
        p["title"], 
        p["desc"], 
        p["keywords"], 
        p["h1"], 
        p["content_html"],
        p.get("schema_type", "LocalBusiness")
    )

print("Main pages generated successfully.")
