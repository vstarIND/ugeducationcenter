$oldFooter = @"
    <footer class="site-footer">
        <div class="footer-content">
           
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 U.G. Education Centre. All Rights Reserved.</p>
        </div>
    </footer>
"@

$newFooter = @"
    <footer class="site-footer">
        <div class="footer-content">
            <div class="footer-section footer-about">
                <h3 class="footer-title">U.G. Education Centre</h3>
                <p>Harvesting Talent, Cultivating Leaders. The premier CBSE school in Akbarpur, Kanpur Dehat.</p>
            </div>
            <div class="footer-section footer-links">
                <h3 class="footer-title">Quick Links</h3>
                <ul>
                    <li><a href="/">Home</a></li>
                    <li><a href="/about-school/">About Us</a></li>
                    <li><a href="/admissions/">Admissions</a></li>
                    <li><a href="/facilities/">Facilities</a></li>
                </ul>
            </div>
            <div class="footer-section footer-links">
                <h3 class="footer-title">Explore</h3>
                <ul>
                    <li><a href="/blog/">Education Blog</a></li>
                    <li><a href="/cbse-school-in-akbarpur/">CBSE School in Akbarpur</a></li>
                    <li><a href="/best-school-in-kanpur-dehat/">Best School in Kanpur Dehat</a></li>
                    <li><a href="/contact/">Contact Us</a></li>
                </ul>
            </div>
            <div class="footer-section footer-social">
                <h3 class="footer-title">Connect</h3>
                <a href="tel:+917499458100">📞 +91 74994 58100</a>
                <a href="mailto:ugeducationcenter@gmail.com">✉️ Email Us</a>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 U.G. Education Centre. All Rights Reserved.</p>
        </div>
    </footer>
"@

# Standardize line endings just in case
$oldFooterRegex = [regex]::Escape($oldFooter).Replace("\r\n", "\r?\n")

$files = Get-ChildItem -Path "c:\Users\AVN\Downloads\uged" -Filter "index.html" -Recurse
foreach ($file in $files) {
    if ($file.FullName -eq "c:\Users\AVN\Downloads\uged\index.html") { continue }
    $content = Get-Content $file.FullName -Raw
    # The replacement can be tricky with string exact match due to CRLF, use regex
    $content = $content -replace "(?s)<footer class=`"site-footer`">.*?</footer>", $newFooter
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
}
Write-Output "Footers updated in all files."
