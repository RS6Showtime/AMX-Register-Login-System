#if defined _register_included
  #endinput
#endif
#define _register_included

// Returneaza valorea de adevarata sau falsa, daca jucatorul a fost gasit in baza de date

native user_exist(id);

// Returneaza valorea de adevarata sau falsa, daca jucatorul s-a logat cu success

native user_loggedin(id);

// Returneaza valoarea parolei introduse de utilizator la register/login/change password

native get_user_password(id, const Variable[], len);

// Returneaza valoarea parolei incarcata din baza de date a utilizatorului

native get_user_password_mysql(id, const Variable[], len);