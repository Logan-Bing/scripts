#!/bin/bash

# newclass Person -a name age Monster -p name age

# string -> std::string
# int -> int
# char -> char
# char * -> char *

# Pour gérer les arguments il faudrait trouver un moyen de comment le preciser, 
# pour commencer que les types primitifs avec des prefixes exemple: s_name -> std::string name

# Il faut pouvoir réussir a parcourir la liste d'arguments des que un flag est trouvé et s'arreter quand il n'y a plus d'arguments ou un autre flag
#
# newclass Person string name int age
#


writeHppHeader()
{
	cat <<-EOF > ${hpp_file}
		#ifndef __${name_up}_HPP__
		#define __${name_up}_HPP__

		#include <iostream>
	EOF
}

writeHppPublic()
{
	cat <<-EOF >> ${hpp_file}

	class ${name} {
	 public:
	  // Constuctor/Destructor
	  ${name}(void);
	  ${name}(const ${name}& other);
	  ${name}& operator=(const ${name}& rhs);
	  ~${name}(void);
	EOF

}

writeHppPrivate()
{
	cat <<-EOF >> ${hpp_file}

	 private:
	EOF

	for e in "${ATTRIBUTS[@]}";
	do
		cat <<-EOF >> ${hpp_file}
		  ${e};
		EOF
	done
}

writeHppFooter()
{
	cat <<-EOF >> ${hpp_file}

	};

	#endif
	EOF
}

writeCppFile()
{
	cat <<EOF > ${cpp_file}
#include "${name}.hpp"
#include "Debug.hpp"

${name}::${name}(void)
{
	DEBUG("${name} Default Constuctor called\n");
}

${name}::${name}(const ${name}& other)
{
	DEBUG("${name} Copy Constructor called\n");
}

${name}&	${name}::operator=(const ${name}& rhs)
{
	if (this != &rhs)
	{
	
	}
	return *this;
}

${name}::~${name}(void)
{
	DEBUG("${name} Destructor called\n");
}
EOF
}

types=(
	'string-std::string'
	'int-int'
)


argv=("$@")

name="$(echo ${argv[0]:0:1} | tr '[:lower:]' '[:upper:]')${argv[0]:1}"
name_up=$(echo ${argv[0]} | tr '[:lower:]' '[:upper:]');
hpp_file="${name}.hpp"
cpp_file="${name}.cpp"

ATTRIBUTS=()

for ((i=0; i<${#argv[@]}; i++)); do
	for index in "${types[@]}"; do
		KEY="${index%%-*}"
		VALUE="${index##*-}"
		if [[ "${argv[i]}" == "${KEY}" ]]; then
			attr="${VALUE} ${argv[i+1]}"
			ATTRIBUTS+=("${attr}")
			((i++))   # consomme le nom
			break
		fi
	done
done

writeHppHeader
writeHppPublic
writeHppPrivate
writeHppFooter
writeCppFile

