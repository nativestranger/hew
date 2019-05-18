const fs = require('fs');
const path = require('path');

module.exports = {
  loader: 'resolve-url-loader',
  options: {
    join: (uri, options) => {
      return (filename, base) => {
        // Add lookup folder path you want
        const sourceFolders = [
          'app/assets/images',
          'app/assets/fonts'
        ];
        const paths = sourceFolders.map((folder) => {
          if (fs.existsSync(`${folder}/${filename}`)) {
            return path.normalize(`${folder}/${filename}`);
          } else {
            return;
          }
        });
        return paths.filter(s => s)[0] || uri;
      }
    }
  }
}
