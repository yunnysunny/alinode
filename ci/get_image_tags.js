const {getImageName} = require('./util')
const args = process.argv.slice(2);

const imageName = args[0];
const tagsStr = getImageName(imageName);
console.log(tagsStr.join(','));