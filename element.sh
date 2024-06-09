#!/bin/bash
#adding comment
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRINT_ELEMENT() {
# if not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    TRY_SYMBOL=$($PSQL "SELECT * FROM ELEMENTS WHERE symbol = '$1'";)
    if [[ -z $TRY_SYMBOL ]]
    then
      TRY_NAME=$($PSQL "SELECT * FROM elements WHERE name = '$1'";)
      if [[ -z $TRY_NAME ]]
      then
        echo "I could not find that element in the database."
      else
      #input is name
        NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'";)
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'";)
        TYPE=$($PSQL "SELECT type FROM types inner join properties on types.type_id = properties.type_id WHERE atomic_number = '$NUMBER'";)
        MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$NUMBER'";)
        MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$NUMBER'";)
        BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$NUMBER'";)
        echo -e "The element with atomic number $NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      fi
    else
    # input is symbol
      NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'";)
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'";)
      TYPE=$($PSQL "SELECT type FROM types inner join properties on types.type_id = properties.type_id WHERE atomic_number = '$NUMBER'";)
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$NUMBER'";)
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$NUMBER'";)
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$NUMBER'";)
      echo -e "The element with atomic number $NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
  else
  # is a number
  TRY_NUMBER=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1";)
   if [[ -z $TRY_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
    #input es atomic number
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1";)
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1";)
      TYPE=$($PSQL "SELECT type FROM types inner join properties on types.type_id = properties.type_id WHERE atomic_number = $1";)
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1";)
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1";)
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1";)
      echo -e "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
  fi
}

if [[ $1 ]]
then
  PRINT_ELEMENT $1
else
  echo -e "Please provide an element as an argument."
fi
