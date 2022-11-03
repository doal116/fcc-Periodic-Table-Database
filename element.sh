#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

TEXT_OUPUT(){
  echo "$ELEMENT" | while read ATOMI BAR SYMBOL BAR NAME
  do
    MORE_INFO=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMI;")
    
    echo "$MORE_INFO" | while read ATOM BAR ATOM_M BAR MELT_P BAR BOIL_P BAR TYPE_ID
    do
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
      echo "The element with atomic number $ATOMI is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOM_M amu. $NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
    done
  done
}
DATA_PRESENCE(){
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    TEXT_OUPUT $ELEMENT
  fi
}

SEARCHING_TOOL(){
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
      ELEMENT=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE symbol='${1^}' OR name='${1^}';")
      DATA_PRESENCE $ELEMENT
  else
    ELEMENT=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE atomic_number='$1';")
      DATA_PRESENCE $ELEMENT
  fi
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  SEARCHING_TOOL $1
fi