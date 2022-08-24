const dockerRegistry = process.env.DOCKER_REPO + '/yunnysunny';
exports.getImageName = function(imageName) {

    let tagName = process.env.CI_COMMIT_TAG;
    if (tagName.startsWith('v')) {
        tagName = tagName.substring(1);
    }
    const versions = [];
    const versionStr = tagName.split('.');
    let pervious = '';
    let current = '';
    for (let i=0,len=versionStr.length;i<len;i++) {
        if (i > 0) {
            current = pervious + '.' + versionStr[i];
        } else {
            current = versionStr[0];
        }
        
        versions.push(current);
        pervious = current;
    }

    const tagsStr = versions.map(function(item) {
        return `${dockerRegistry}/alinode-${imageName}:${item}`;
    });
    return tagsStr;
};