rm -r docs
reveal-md slides.md --static --static-dirs=assets
mv _static docs
