# GitHub Pages Setup Guide

Your AIMBTI website is ready to be hosted on GitHub Pages! Follow these steps to make it live:

## Quick Setup

1. **Go to your repository on GitHub**: https://github.com/WeiProduct/MBTI

2. **Navigate to Settings**:
   - Click on the "Settings" tab in your repository

3. **Configure GitHub Pages**:
   - Scroll down to the "Pages" section in the left sidebar
   - Under "Source", select "Deploy from a branch"
   - Under "Branch", select "main"
   - Under "Folder", select "/docs"
   - Click "Save"

4. **Wait for deployment** (usually takes 2-10 minutes)

5. **Access your website**:
   - Your site will be available at: https://weiproduct.github.io/MBTI/

## Features of Your Website

- **Responsive Design**: Works perfectly on desktop, tablet, and mobile
- **Bilingual Support**: Toggle between English and Chinese with one click
- **Modern UI**: Clean, professional design with smooth animations
- **SEO Friendly**: Proper meta tags and semantic HTML
- **Fast Loading**: Vanilla JS/CSS for optimal performance

## Customization

### Adding Real Screenshots

1. Take screenshots of your app (recommended sizes):
   - Hero image: 300x600px
   - Gallery images: 250x500px

2. Save them in `docs/assets/images/` with these names:
   - `app-preview.png`
   - `screenshot-1.png` through `screenshot-5.png`

### Updating Content

- Edit text in `docs/index.html`
- Modify styles in `docs/assets/css/style.css`
- Update functionality in `docs/assets/js/script.js`

### Adding App Store Links

When your app is published, update the download buttons in the HTML:
- Search for "Coming Soon" and replace with actual App Store URL
- Update TestFlight link with your beta testing URL

## Troubleshooting

If the site doesn't appear after 10 minutes:
1. Check repository settings to ensure Pages is enabled
2. Verify the branch and folder settings
3. Check for any build errors in the Actions tab
4. Ensure the repository is public

## Next Steps

1. Add real app screenshots
2. Update download links when app is published
3. Consider adding:
   - Privacy policy page
   - Terms of service page
   - Blog or updates section
   - Contact form

Your website is now live! Share it with the world: https://weiproduct.github.io/MBTI/