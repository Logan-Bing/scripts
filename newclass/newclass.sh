#!/bin/bash

# newclass Person -a name age Monster -p name age


# Pour gérer les arguments il faudrait trouver un moyen de comment le preciser, 
# pour commencer que les types primitifs avec des prefixes exemple: s_name -> std::string name

# Il faut pouvoir réussir a parcourir la liste d'arguments des que un flag est trouvé et s'arreter quand il n'y a plus d'arguments ou un autre flag

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
	  ${name}(${name}& other);
	  ${name}& operator=(${name}& rhs);
	  ~${name}(void);
	  // attributes
	EOF

	# if [ "${flags_a}"  -eq 1 ]; then
	# 	for((i = 2; i < ${length}; i++)); do
	#
	# 		cat <<-EOF >> ${hpp_file}
	# 			  ${spec[i]};
	# 		EOF
	#
	# 	done
	# fi
}

writeHppPrivate()
{
	cat <<-EOF >> ${hpp_file}

	 private:
	EOF
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

${name}::${name}(void)
{
	std::cout << "${name} Default Constuctor called\n";
}

${name}::~${name}(void)
{
	std::cout << "${name} Destructor called\n";
}
EOF
}

options=("-a" "-p")

for arg in "$@"; do

	flags_a=0
	flags_p=0

	IFS=" " read -r -a spec <<< "${arg}"

	name="$(echo ${spec[0]:0:1} | tr '[:lower:]' '[:upper:]')${spec[0]:1}"
	name_up=$(echo ${spec[0]} | tr '[:lower:]' '[:upper:]');
	hpp_file="${name}.hpp"
	cpp_file="${name}.cpp"

	length=${#spec[@]}

	for ((j=0; j < ${length}; j++)); do

		if [ ${spec[j]} == ${options[0]} ]; then
			flags_a=1
		fi

		if [ ${spec[j]} == ${options[1]} ]; then
			flags_p=1
		fi

	done

	writeHppHeader
	writeHppPublic
	writeHppPrivate
	writeHppFooter
	writeCppFile

done
