maintainer       "Javier Perez-Griffo Callejon"
maintainer_email "javier@besol.es"
license          "Apache 2.0"
description      "Installs/Configures Ximdex Publishing Server (Web UI compatible with Firefox only)"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.2"
recipe           "ximdex", "Installs and configures Ximdex Publishing Server"

%w(apt mysql php apache2).each do |recipe_dependency|
  depends recipe_dependency
end

%w{ ubuntu debian }.each do |os|
  supports os
end
