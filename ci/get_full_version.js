let tagName = process.env.CI_COMMIT_TAG;
if (tagName.startsWith('v')) {
    tagName = tagName.substring(1);
}
console.log(tagName);