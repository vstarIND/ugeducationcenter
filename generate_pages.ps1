$htmlContent = Get-Content -Path "c:\Users\AVN\Downloads\uged\index.html" -Raw

$headMatch = [regex]::Match($htmlContent, '(?s)(<head>.*?</head>)')
$bodyStartMatch = [regex]::Match($htmlContent, '(?s)(<body.*?>\s*<div id="loader-wrapper">.*?<header>.*?</header>)')
$footerMatch = [regex]::Match($htmlContent, '(?s)(<footer.*?</footer>.*?</body>\s*</html>)')

$headTemplate = $headMatch.Groups[1].Value
$bodyStart = $bodyStartMatch.Groups[1].Value
$footer = $footerMatch.Groups[1].Value

$navLinks = @"
                <nav class="nav-links">
                    <a href="/">HOME</a>
                    <a href="/about-school/">ABOUT</a>
                    <a href="/admissions/">ADMISSIONS</a>
                    <a href="/facilities/">FACILITIES</a>
                    <a href="/blog/">BLOG</a>
                    <a href="/contact/">CONTACT</a>
                </nav>
"@
$bodyStart = $bodyStart -replace '(?s)<nav class="nav-links">.*?</nav>', $navLinks

function Create-Page {
    param (
        [string]$Path,
        [string]$Title,
        [string]$Desc,
        [string]$Keywords,
        [string]$H1,
        [string]$ContentHtml,
        [string]$SchemaType = "LocalBusiness"
    )

    $dirPath = "c:\Users\AVN\Downloads\uged\$Path"
    if (!(Test-Path $dirPath)) {
        New-Item -ItemType Directory -Force -Path $dirPath | Out-Null
    }
    
    $newHead = $headTemplate -replace '<title>.*?</title>', "<title>$Title | U.G. Education Centre</title>"
    $newHead = $newHead -replace '<meta name="description" content=".*?">', "<meta name=`"description`" content=`"$Desc`">"
    $newHead = $newHead -replace '<meta name="keywords" content=".*?">', "<meta name=`"keywords`" content=`"$Keywords`">"
    $newHead = $newHead -replace '<link rel="canonical" href=".*?">', "<link rel=`"canonical`" href=`"https://ugeducation.center/$Path/`">"
    
    $schema = @"
{
  "@context": "https://schema.org",
  "@type": "$SchemaType",
  "name": "U.G. Education Centre",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Akbarpur",
    "addressRegion": "Kanpur Dehat",
    "addressCountry": "India"
  },
  "url": "https://ugeducation.center/$Path/"
}
"@
    $newHead = $newHead -replace '(?s)<script type="application/ld\+json">.*?</script>', "<script type=`"application/ld+json`">`n$schema`n</script>"

    $pageHtml = @"
<!DOCTYPE html>
<html lang="en">
$newHead
$bodyStart

    <section class="new-section-container" style="background-color: #000; padding: 120px 40px 60px;">
        <h1 class="section-title" style="color: var(--bright-yellow); font-size: 3rem;">$H1</h1>
    </section>

    <div class="page-content" style="max-width: 1200px; margin: 0 auto; padding: 40px; color: rgba(255,255,255,0.9); font-family: 'Poppins', sans-serif; line-height: 1.8;">
        $ContentHtml
    </div>

$footer
"@

    Set-Content -Path "$dirPath\index.html" -Value $pageHtml -Encoding UTF8
}

Create-Page -Path "admissions" -Title "Admissions" -Desc "Information on admissions at UG Education Centre in Akbarpur, Kanpur Dehat." -Keywords "admissions UG Education Centre, CBSE school admission" -H1 "Admissions at U.G. Education Centre" -ContentHtml @"
<h2>Welcome to the Admissions Process</h2>
<p>Choosing the right school for your child is one of the most important decisions you will make. At U.G. Education Centre, recognized as the best school in Kanpur Dehat, we are committed to making the admission process as seamless as possible.</p>
<h3>Admission Criteria</h3>
<p>We welcome students from all backgrounds. Admission is purely based on merit and the availability of seats. The process involves:</p>
<ul>
    <li>Submission of the completed application form.</li>
    <li>An interactive session with the student and parents.</li>
    <li>Review of previous academic records.</li>
</ul>
<div style="margin-top: 40px; border-top: 1px solid #333; padding-top: 20px;">
    <h2>Frequently Asked Questions (FAQs)</h2>
    <h3 style="color: var(--bright-yellow);">What is the age criteria for Play Group?</h3>
    <p>Children must be 3 years of age by March 31st of the academic year.</p>
    <h3 style="color: var(--bright-yellow);">Are transport facilities available?</h3>
    <p>Yes, we offer safe and GPS-tracked transport services across Akbarpur and nearby regions in Kanpur Dehat.</p>
</div>
"@

Create-Page -Path "about-school" -Title "About Our School" -Desc "Learn about the mission, vision, and legacy of U.G. Education Centre in Akbarpur." -Keywords "about UG Education Centre, CBSE school Akbarpur mission" -H1 "About U.G. Education Centre" -ContentHtml @"
<h2>Our Vision and Mission</h2>
<p>U.G. Education Centre is not just a school; it is a community dedicated to excellence. Our mission is to provide an environment where every student is inspired to learn, challenged to excel, and empowered to succeed.</p>
<h3>A Legacy of Excellence in Kanpur Dehat</h3>
<p>Through our commitment to traditional values intertwined with modern educational practices, we have established ourselves as the best school in Kanpur Dehat. We focus on ethical growth, innovative learning, and inclusive community building.</p>
<h3>Our Educational Approach</h3>
<p>Being a premier CBSE school in Akbarpur, our curriculum is strictly adherent to the highest educational standards, integrating critical thinking, arts, and sports into daily learning.</p>
<div style="margin-top: 30px;">
    <p>Learn more about what makes learning here special by exploring our <a href="/facilities/" style="color: var(--bright-yellow); text-decoration: underline;">Campus Facilities</a>.</p>
</div>
"@

Create-Page -Path "facilities" -Title "School Facilities" -Desc "Explore the outstanding facilities and infrastructure at U.G. Education Centre." -Keywords "school facilities Akbarpur, campus Kanpur Dehat, smart classrooms" -H1 "Our World-Class Facilities" -ContentHtml @"
<h2>Empowering Education with Infrastructure</h2>
<p>A conducive learning environment is crucial for academic success. U.G. Education Centre boasts a state-of-the-art campus designed for safety, comfort, and interactive learning.</p>
<h3>Smart Classrooms</h3>
<p>Our classrooms are equipped with digital boards and modern teaching aids to make learning engaging and interactive for the students of Kanpur Dehat.</p>
<h3>Library and Laboratories</h3>
<p>We believe in practical knowledge. Our science and computer labs are fully equipped to meet the CBSE curriculum standards, while our extensive library houses thousands of books to cultivate a reading habit.</p>
<div style="margin-top: 40px; border-top: 1px solid #333; padding-top: 20px;">
    <h2>Frequently Asked Questions (FAQs)</h2>
    <h3 style="color: var(--bright-yellow);">Do you have a cafeteria?</h3>
    <p>Yes, we have a hygienic cafeteria providing nutritious meals to students.</p>
    <h3 style="color: var(--bright-yellow);">Is the campus secure?</h3>
    <p>Absolutely. The entire campus is under 24/7 CCTV surveillance with trained security personnel.</p>
</div>
"@

Create-Page -Path "cbse-school-in-akbarpur" -Title "Top CBSE School in Akbarpur" -Desc "Looking for the best CBSE school in Akbarpur? U.G. Education Centre provides holistic education." -Keywords "CBSE school in Akbarpur, top CBSE school Akbarpur" -H1 "Premier CBSE School in Akbarpur" -SchemaType "School" -ContentHtml @"
<h2>Why U.G. Education Centre is the Right Choice</h2>
<p>If you are searching for a CBSE school in Akbarpur that aligns with global standards while retaining core Indian values, your search ends here. We provide an ecosystem where academic rigor meets extracurricular brilliance.</p>
<h3>The CBSE Advantage</h3>
<p>The Central Board of Secondary Education (CBSE) curriculum is recognized worldwide. It emphasizes application-based learning. Our faculty ensures that students grasp concepts practically rather than through rote learning.</p>
<h3>Community Impact</h3>
<p>By bringing top-tier education to Akbarpur, we aim to uplift the entire community, offering students opportunities that par with those in major metropolitan cities.</p>
<div style="margin-top: 30px;">
    <p>Read about our expert insights on education on our <a href="/blog/" style="color: var(--bright-yellow); text-decoration: underline;">Blog</a>.</p>
</div>
"@

Create-Page -Path "best-school-in-kanpur-dehat" -Title "Best School in Kanpur Dehat" -Desc "U.G. Education Centre is widely recognized as the best school in Kanpur Dehat." -Keywords "best school in Kanpur Dehat, top schools Kanpur Dehat" -H1 "The Best School in Kanpur Dehat" -SchemaType "School" -ContentHtml @"
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
</div>
"@

Create-Page -Path "contact" -Title "Contact Us" -Desc "Get in touch with U.G. Education Centre. Address, phone, and email information." -Keywords "contact UG Education Centre, school address Akbarpur" -H1 "Contact U.G. Education Centre" -ContentHtml @"
<h2>We'd Love to Hear From You</h2>
<p>Whether you have a question about admissions, facilities, or our curriculum, our team is ready to answer all your questions.</p>
<div style="background: rgba(255,255,255,0.05); padding: 30px; border-radius: 15px; margin-top: 30px;">
    <h3>Our Detailed Contact Information</h3>
    <p><strong>Address:</strong> Gokuldham Society, Shahjadpur, Akbarpur, Kanpur Dehat, Uttar Pradesh, 209101</p>
    <p><strong>Phone:</strong> +91 74994 58100</p>
    <p><strong>Email:</strong> ugeducationcenter@gmail.com</p>
</div>
"@

# Sub-function for Blogs
function Create-BlogPage {
    param (
        [string]$Slug,
        [string]$Title,
        [string]$Content
    )
    $path = "blog/$Slug"
    $desc = "Read about $Title at U.G. Education Centre's official blog."
    $keywords = "$Title, U.G. Education blog, CBSE school articles"
    
    $fullContent = @"
<article class="blog-post">
    $Content
    <div style="margin-top: 40px;">
        <a href="/blog/" style="color: var(--bright-yellow); text-decoration: underline;">&larr; Back to all blogs</a>
    </div>
</article>
"@
    Create-Page -Path $path -Title $Title -Desc $desc -Keywords $keywords -H1 $Title -ContentHtml $fullContent -SchemaType "Article"
}

# Main Blog Page
Create-Page -Path "blog" -Title "Education Blog" -Desc "Read the latest news, updates, and educational articles from U.G. Education Centre." -Keywords "education blog Kanpur Dehat, school updates Akbarpur" -H1 "Our Education Blog" -ContentHtml @"
<div class="blog-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px;">
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Best CBSE Schools in Akbarpur</h3>
        <p>Discover what makes a great CBSE school and why U.G. Education Centre stands out from the rest.</p>
        <a href="/blog/best-cbse-schools-in-akbarpur/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Why Choose CBSE Board?</h3>
        <p>A comprehensive guide on the benefits of the CBSE curriculum for early and higher education.</p>
        <a href="/blog/why-choose-cbse-board/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Top Schools in Kanpur Dehat</h3>
        <p>A detailed comparison of school facilities, methodologies, and outcomes in Kanpur Dehat.</p>
        <a href="/blog/top-schools-in-kanpur-dehat/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">How to Choose School for Your Child</h3>
        <p>Five crucial factors parents must consider before enrolling their child in a primary or secondary school.</p>
        <a href="/blog/how-to-choose-school-for-child/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <!-- Adding 6 more to hit the 10 articles requirement -->
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Importance of Extracurriculars</h3>
        <p>Why sports and arts are just as critical as mathematics and science in modern education.</p>
        <a href="/blog/importance-of-extracurriculars/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Future-Ready Education</h3>
        <p>Preparing the next generation for challenges through innovative teaching methodologies.</p>
        <a href="/blog/future-ready-education/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Understanding Holistic Development</h3>
        <p>Deep dive into what holistic development actually means in a school setting.</p>
        <a href="/blog/understanding-holistic-development/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Role of Technology in Education</h3>
        <p>How smart classrooms are changing the way students in Kanpur Dehat learn today.</p>
        <a href="/blog/role-of-technology-in-education/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Parent-Teacher Synergy</h3>
        <p>Why communication at home reflects on the student's performance at school.</p>
        <a href="/blog/parent-teacher-synergy/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
    <div class="blog-card" style="background: rgba(255,255,255,0.05); padding: 25px; border-radius: 15px; border: 1px solid rgba(255,210,30,0.3);">
        <h3 style="color: var(--bright-yellow); margin-bottom: 10px;">Building Confidence in Kids</h3>
        <p>Actionable advice for parents and educators to help build self-esteem in young learners.</p>
        <a href="/blog/building-confidence-in-kids/" style="color: white; text-decoration: underline; display: inline-block; margin-top: 15px;">Read Full Article</a>
    </div>
</div>
"@

# Create the 10 blog posts
Create-BlogPage -Slug "best-cbse-schools-in-akbarpur" -Title "Best CBSE Schools in Akbarpur" -Content @"
<h2>Finding the Perfect School in Akbarpur</h2>
<p>In Akbarpur, selecting from the best CBSE schools can be daunting. You want an institution that seamlessly balances academic excellence with holistic development and a safe campus culture.</p>
<h3>Our Proven Methodologies</h3>
<p>At U.G. Education Centre, we use an inquiry-based model characteristic of the CBSE curriculum. This encourages students to ask questions instead of merely memorizing answers.</p>
<p>Moreover, our experienced faculty, continuously trained in modern pedagogies, ensures each student receives personalized attention.</p>
"@

Create-BlogPage -Slug "why-choose-cbse-board" -Title "Why Choose CBSE Board?" -Content @"
<h2>The Power of CBSE Curriculum</h2>
<p>The Central Board of Secondary Education (CBSE) remains one of the most popular and trusted educational boards in India. But why should you choose it?</p>
<h3>National Acceptability</h3>
<p>Its widespread acceptance across the country makes it highly beneficial for parents with transferable jobs. Also, syllabi for major competitive exams (like JEE and NEET) are largely based on the CBSE curriculum.</p>
<p>With an emphasis on analytical and logical reasoning over rote-learning, students from CBSE schools like U.G. Education Centre in Kanpur Dehat typically show robust problem-solving skills.</p>
"@

Create-BlogPage -Slug "top-schools-in-kanpur-dehat" -Title "Top Schools in Kanpur Dehat" -Content @"
<h2>Evaluating Schools in Kanpur Dehat</h2>
<p>Kanpur Dehat has seen significant growth in its educational sector, with several institutions vying for the title of the top school. What differentiates the good from the great?</p>
<h3>Infrastructure Meets Empathy</h3>
<p>The top schools, including U.G. Education Centre, offer more than just brick and mortar. They offer sports facilities, arts programs, and a compassionate teaching staff.</p>
<p>We pride ourselves on offering a sanctuary of learning where security, emotional intelligence, and technological literacy go hand in hand.</p>
"@

Create-BlogPage -Slug "how-to-choose-school-for-child" -Title "How to Choose School for Your Child" -Content @"
<h2>A Parent's Guide to School Selection</h2>
<p>A school lays the foundation for your child's future. Here is how you can ensure you pick the right one:</p>
<ul>
    <li><strong>Curriculum & Boards:</strong> Does the school follow a recognized board like CBSE?</li>
    <li><strong>Teacher-to-Student Ratio:</strong> Ensure your child won't get lost in a crowded classroom.</li>
    <li><strong>Extracurriculars:</strong> Does the school prioritize physical and creative development?</li>
    <li><strong>Values:</strong> Do the school's core values align with your family's?</li>
</ul>
<p>These are the exact areas U.G. Education Centre excels in.</p>
"@

Create-BlogPage -Slug "importance-of-extracurriculars" -Title "Importance of Extracurriculars" -Content @"
<h2>Beyond the Textbook</h2>
<p>Education is an all-encompassing journey. True learning happens as much on the playground or the debate stage as it does inside a classroom.</p>
<p>Through our comprehensive extracurricular syllabus, we actively encourage our students to explore art, athletics, coding, and performing arts. This fosters resilience, teamwork, and innovative thinking.</p>
"@

Create-BlogPage -Slug "future-ready-education" -Title "Future-Ready Education" -Content @"
<h2>Preparing for Tomorrow, Today</h2>
<p>The job landscape is constantly evolving. A future-ready education involves teaching kids 'how to think' rather than 'what to think'.</p>
<p>U.G. Education Centre integrates modern technological awareness and critical thinking exercises into daily subjects, ensuring our students are prepared for the challenges of tomorrow.</p>
"@

Create-BlogPage -Slug "understanding-holistic-development" -Title "Understanding Holistic Development" -Content @"
<h2>Caring for the Whole Child</h2>
<p>Holistic development addresses a child's social, emotional, physical, and cognitive growth.</p>
<p>By offering excellent counseling, sports programs, and empathy-building activities, U.G. Education Centre ensures that every student matures into a balanced and responsible adult.</p>
"@

Create-BlogPage -Slug "role-of-technology-in-education" -Title "Role of Technology in Education" -Content @"
<h2>Smart Classrooms, Smart Kids</h2>
<p>From smart boards to digital labs, technology is reshaping education in Kanpur Dehat.</p>
<p>At U.G. Education Centre, we carefully blend digital tools with traditional teaching methods to create highly engaging and memorable lessons that cater to multiple learning styles.</p>
"@

Create-BlogPage -Slug "parent-teacher-synergy" -Title "Parent-Teacher Synergy" -Content @"
<h2>A Collaborative Effort</h2>
<p>Education doesn't stop when the school bell rings. Consistent communication between parents and educators leads to higher student achievement.</p>
<p>Our regular Parent-Teacher Meetings and open-door policies at U.G. Education Centre ensure that parents are always in the loop regarding their child's progress.</p>
"@

Create-BlogPage -Slug "building-confidence-in-kids" -Title "Building Confidence in Kids" -Content @"
<h2>Nurturing Self-Esteem</h2>
<p>Confidence is key to a child's success. At U.G. Education Centre, we build confidence by celebrating small victories, encouraging public speaking, and creating a safe environment where making mistakes is seen as a learning opportunity.</p>
<p>We believe every child has a unique talent waiting to be discovered.</p>
"@

Write-Output "Basic and blog pages created successfully."
