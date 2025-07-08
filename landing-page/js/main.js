// Tab functionality
document.addEventListener('DOMContentLoaded', function() {
    // Hero code tabs
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetTab = button.getAttribute('data-tab');
            
            // Update buttons
            tabButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // Update content
            tabContents.forEach(content => {
                if (content.getAttribute('data-content') === targetTab) {
                    content.classList.add('active');
                } else {
                    content.classList.remove('active');
                }
            });
        });
    });
    
    // CLI command selector
    const commandButtons = document.querySelectorAll('.command-btn');
    const commandOutputs = document.querySelectorAll('.command-output');
    
    commandButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetCommand = button.getAttribute('data-command');
            
            // Update buttons
            commandButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // Update output
            commandOutputs.forEach(output => {
                if (output.getAttribute('data-output') === targetCommand) {
                    output.classList.add('active');
                } else {
                    output.classList.remove('active');
                }
            });
        });
    });
    
    // Copy buttons
    const copyButtons = document.querySelectorAll('.copy-btn');
    
    copyButtons.forEach(button => {
        button.addEventListener('click', async () => {
            const text = button.getAttribute('data-text');
            
            try {
                await navigator.clipboard.writeText(text);
                button.textContent = 'Copied!';
                button.classList.add('copied');
                
                setTimeout(() => {
                    button.textContent = 'Copy';
                    button.classList.remove('copied');
                }, 2000);
            } catch (err) {
                console.error('Failed to copy:', err);
            }
        });
    });
    
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add copy buttons to code blocks
    document.querySelectorAll('.code-block').forEach(block => {
        if (!block.querySelector('.copy-btn')) {
            const pre = block.querySelector('pre');
            const code = pre.querySelector('code').textContent;
            
            const copyBtn = document.createElement('button');
            copyBtn.className = 'copy-btn';
            copyBtn.textContent = 'Copy';
            copyBtn.setAttribute('data-text', code);
            
            block.style.position = 'relative';
            block.appendChild(copyBtn);
            
            copyBtn.addEventListener('click', async () => {
                try {
                    await navigator.clipboard.writeText(code);
                    copyBtn.textContent = 'Copied!';
                    copyBtn.classList.add('copied');
                    
                    setTimeout(() => {
                        copyBtn.textContent = 'Copy';
                        copyBtn.classList.remove('copied');
                    }, 2000);
                } catch (err) {
                    console.error('Failed to copy:', err);
                }
            });
        }
    });
    
    // Add animation on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe feature cards
    document.querySelectorAll('.feature-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
    
    // Observe example cards
    document.querySelectorAll('.example-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });
});