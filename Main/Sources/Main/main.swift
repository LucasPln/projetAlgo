/* ------- Programme Main ------- */
import Protocols
/* Initialisation de la partie */
print("Joueur 1 : Veuillez saisir un nom pour votre joueur : ")
var choix : String

if let typed = readLine(){
	choix=typed
}
var joueur1 = JoueurProtocol(nom : choix)

print("Joueur 2 : Veuillez saisir un nom pour votre joueur : ")
if let typed = readLine(){
	choix=typed
}
var joueur2 = JoueurProtocol(nom : choix)

var joueurGagnant : JoueurProtocol
var partiFini = false

print("Joueur 1 : veuillez selectionner (un numero) une carte à mettre au royaume")
print(joueur1.main.afficherMain())
var input : Int
var isInt = false
while(!isInt){
	if let typed = readLine(){
		if let n = Int(typed){
			input = n
			isInt = true

		} else {
			print("veuillez choisir un nombre")
		}
	}
}
joueur1.demobiliser(carte : joueur1.recupererCarte(position : input))

print("mettre un carte au front")
print(joueur1.main.afficherMain())
isInt = false
while(!isInt){
	if let typed = readLine(){
		if let n = Int(typed){
			input = n
			isInt = true
		}else{
			print("veuillez choisir un nombre")
		}
	}
}
joueur1.deployerCarte(carte : joueur1.main.recupererCarte(position : input))

print("Joueur 2 : veuillez selectionner (un numero) une carte à mettre au royaume")
print(joueur2.main.afficherMain())
isInt = false
while(!isInt){
	if let typed = readLine(){
		if let n = Int(typed){
			input = n
			isInt = true
		} else {
			print("veuillez choisir un nombre")
		}
	}
}
joueur2.demobiliser(carte: joueur2.main.recupererCarte(position : input))

print("mettre un carte au front")
print(joueur2.main.afficherMain())
isInt = false
while(!isInt){
	if let typed = readLine(){
		if let n = Int(typed){
			input = n
			isInt = true

		} else {
			print("veuillez choisir un nombre")
		}
	}
}
joueur2.deployerCarte(joueur2.main.recupererCarte(position : input))

/* Boucle principale du jeu */
var tour=1
var joueurActuel : JoueurProtocol
var joueurAdverse : JoueurProtocol
while(!partiFini){
	if(tour%2 == 0){
		joueurActuel = joueur2 //attention le joueur doit être de type réference et non pas de type valeur !!!
		joueurAdverse = joueur1
		print("à toi de jouer joueur 2 !")

	} else {
		joueurActuel = joueur1
		joueurAdverse = joueur2
		print("à toi de joueur joueur 1 !")
	}

	/* Mise en position défensive de toutes les cartes du champ de bataille du joueur */
	for carte in joueurActuel.champDeBataille{
		if carte is Carte{
            carte.changerEtat(etat: etatCarte.defensif)
		}
	}

	if(joueurActuel.pioche.nombreOccurence()>0){
		joueurActuel.piocher()

	/* Si les deux joueurs n'ont plus de carte dans leur pioche, on regarde qui à le plus de carte dans son royaume pour désigner le gagnant*/
	} else if (joueurAdverse.pioche.nombreOccurence() == 0){
		if(joueurActuel.royaume.nombreOccurence()>joueurAdverse.royaume.nombreOccurence()){
			joueurGagnant = joueurActuel

		} else {
			joueurGagnant = joueurAdverse
		}

		partiFini = true;
		break
		
	}

	print(joueurActuel.afficherChampDeBataille(joueurAdverse : joueurAdverse))
	print(joueurActuel.main.afficherMain())

	//phase action
	if let typed = readLine(){
		choix=typed
	}
	/* Choix de l'action à faire pour ce tour */ 
	print("Veuillez saisir une action à faire (attaquer / deployer / rien) : ")
	while(choix != "rien" || choix != "deployer" || choix != "attaquer"){
		print("saisi non valide, veuillez réitérer")
		if let typed = readLine(){
			choix = typed
		}
	}

	/* Choix de ne rien faire */
	if(choix == "rien"){
		print("vous decidez de passer votre tour")

	/* Choix d'attaquer l'adversaire */
	} else if (choix == "attaquer"){
		var attaque = true
		var attaquer : CarteProtocol
		while(attaque){
	var pouvantAttaquer = joueurActuel.peutAttaquer()
         var cible = joueurActuel.ciblesDisponible(joueur : joueurAdverse)
			if(cible.count>0 || pouvantAttaquer){
				print(joueurActuel.afficherCiblesDisponible(joueur : joueurAdverse))
				print("Choisir une cible ou arreter l'attaque avec \"stop\"")
				var valide = false

				while(!valide){
					if let typed = readLine(){
						if let n = Int(typed){
							input = n
							valide = true
							attaquer = cible[input]

						} else if (typed == "stop"){
							valide = true
							print("l'attaque est stoppée !")
							attaque = false

						} else {
							print("veuillez choisir une action correcte")
						}
					}
				}

				if(attaque==true){
					var changerCible = false
					var cibleMorte = false

					while(changerCible == false || cibleMorte == false){
                        			var unite = joueurActuel.unitePouvantAttaquer(carte : attaquer) //ne montrer que les soldats qui sont en mode defensif

						if(unite.count>0){ // Si le joueur possède des cartes capable d'atteindre des cartes ennemis
							print(joueurActuel.afficherUnitePouvantAttaquer(carte : attaquer))
							print("Avec quelle carte voulez vous attaquer ? (tapez un numero) ou changer de cible ? (tapez \"changer\")")

							while(!valide){
								if let typed = readLine(){
									if let n = Int(typed){
										input = n
										valide = true
										var attaquant = unite[input] //selection d'un attaquant
                                        if(joueurActuel.attaquer(carteAttaquante: attaquant,carteAttaque: attaquer)){
											print("La carte attaquée est tombé au combat !")
											cibleMorte = true
                                            if(attaquer.unite == uniteCarte.Roi){
                                                joueurGagnant = joueurActuel
                                                partiFini = true
                                                break

                                            } else if (joueurAdverse.champDeBatailleEstVide()){ // Si le joueur adverse n'a plus d'unite sur son champ de bataille
                                                if(joueurAdverse.royaume.nombreOccurence() + joueurAdverse.main.nombreOccurence() < 1){ // Si il n'a plus de carte dans le royaume ni dans la main : effondrement
                                                    joueurGagnant = joueurActuel
                                                    partiFini = true
                                                    break

                                                } else { // Si il lui reste au moins une carte dans la main ou dans le royaume : conscription
                                                	if(!joueurAdverse.royaume.estVide()){
                                                    joueurAdverse.deployerCarte(carte : joueurAdverse.royaume.enleverCarte())

	                                                } else {
	                                                	print(joueurActuel.main.afficherMain())
	                                                    print(joueurAdverse.nom+" veuillez choisir une carte à deployer")
	                                                    var isInt = false

	                                                    while(!isInt){
	                                                        if let typed = readLine(){
	                                                            if let n = Int(typed){
	                                                                input = n
	                                                                isInt = true

	                                                            } else {
	                                                                print(joueurAdverse.nom+" veuillez choisir un nombre")
	                                                            }
	                                                        }
	                                                    }
	                                                    joueurAdverse.deployerCarte(carte : joueurAdverse.main.recupererCarte(position: input))
	                                                    print("carte deployé !")
	                                                   
	                                                }
                                                }
                                            }
										}

									} else if(typed == "changer"){
										valide = true
										print("vous avez choisi de changer de cible")
										changerCible = true

									} else {
										print("veuillez choisir une réponse valide")
									}
								}
							}

						} else {
							print("aucune unité ne peut attaquer cette cible")
							changerCible = true
						}
					}
				}

			} else {
				print("il n'y a aucune cible adverse...")
				attaque = false
			}
		}

	/* Choix de déployer une carte sur le champ de bataille */
	} else if(choix == "deployer"){
		print("veuillez choisir une carte à deployer")
		var isInt = false

		while(!isInt){
			if let typed = readLine(){
				if let n = Int(typed){
					input = n
					isInt = true

				} else {
					print("veuillez choisir un nombre")
				}
			}
		}

		joueurActuel.deployerCarte(carte : joueurActuel.main.recupererCarte(position: input))
		print("carte deployé !")
	}
	tour = tour+1
}

print(joueurGagnant.nom+" est le gagnant de la partie !")
