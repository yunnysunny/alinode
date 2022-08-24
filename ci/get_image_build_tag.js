const {getImageName} = require('./util')
const args = process.argv.slice(2);

const imageName = args[0];
const tagsStr = getImageName(imageName).map(function(item) {
    return `-t ${item}`;
});
console.log(tagsStr.join(' '));
