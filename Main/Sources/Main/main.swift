/* ------- Programme Main ------- */
import Protocols


//permet d'afficher le camp d'un joueur
func afficherChampBataile(joueur: Joueur){
var ligne : String
print("**********************************************")
for(let i =0;i<3;++i){
	
	if(joueur.recupererChampDeBataille(joueur: joueur)[i] is Carte){
		ligne += "-"+joueur.recupererChampDeBataille(joueur: joueur)[i].recupererNomCarte()+"-"
	}else{
		ligne += "-"+"          "+"-"
	}
		
}
print(ligne)
ligne = ""
//deuxième ligne
for(let i =3;i<6;++i){
	
	if(joueur.recupererChampDeBataille(joueur: joueur)[i] is Carte){
		ligne += "-"+joueur.recupererChampDeBataille(joueur: joueur)[i].recupererNomCarte()+"(id:"+Joueur.main.recupererMain()[i].recupererIdCarte()+") -"
	}else{
		ligne += "-"+"          "+"-"
	}		
}
print(ligne)
print("********************************************")

}


//permet d'afficher la  main d'un joueur
func afficherMain(joueur: Joueur){
var ligne : String
print("**********************************************")
for(let i =0;i<Joueur.main.nbOccurences();++i){
	
	if(Joueur.main.RecupererMain()[i] is Carte){
		ligne += ("-"+Joueur.main.recupererMain()[i].recupererNomCarte()+"(id:"+Joueur.main.recupererMain()[i].recupererIdCarte()+") -")
	}else{
		ligne += ("-"+"   "+"-")
	}
		
}
print(ligne)
print("********************************************")

}


//correspond a afficher graphiquement une liste de carte
func afficherUniter(unite: [Carte]){
var ligne : String
print("**********************************************")
for(let i =0;i<unite.count;++i){
	
	if(unite[i] is Carte){
		ligne += ("-"+unite[i].recupererNomCarte()+"(id:"+unite[i].recupererIdCarte()+") -")
	}else{
		ligne += ("-"+"   "+"-")
	}
		
}
print(ligne)
print("********************************************")

}


func choisirTypeCarte()->uniteCarte{
print("choisissez entre : 1- 2- 3-")
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
var type : UniteCarte;
if(input=="Soldat"){
	type= UniteCarte.Soldat
}
else if(input=="Archer"){
	type= UniteCarte.Archer

else if(input=="Garde"){
	type= UniteCarte.Garde
}
return type
}
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

print("Joueur 1 : veuillez selectionner une carte à mettre au royaume")
print(afficherMain(joueur : joueur1))

joueur1.demobiliser(carte : joueur1.main.recupererCarte(type : choisirTypeCarte()))

print("mettre un carte au front")
print(afficherMain(joueur : joueur1))


joueur1.deployerCarte(carte : joueur1.main.recupererCarte(type : choisirTypeCarte()),x:, y: )

print("Joueur 2 : veuillez selectionner (un numero) une carte à mettre au royaume")
print(afficherMain(joueur : joueur2))

joueur2.demobiliser(carte: joueur2.main.recupererCarte(type : choisirTypeCarte()))

print("mettre un carte au front")
print(afficherMain(joueur : joueur2))

joueur2.deployerCarte(joueur2.main.recupererCarte(type : choisirTypeCarte()),x:, y: )

/* Boucle principale du jeu */
var tour=1
var joueurActuel : JoueurProtocol
var joueurAdverse : JoueurProtocol
var changerCible = false
var cible : Carte
var cibleMorte = false
var valide = false
var unite : [Carte]
var pouvantAttaquer : [Carte]
var attaquer : Carte //carte qui est attaqué
var attaquant : Carte //Carte attaquante
var attaque : false //permettant de lancer une attaque

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
	for carte in joueurActuel.recupererChampDeBataille(joueurActuel){
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
	print("champ de bataille adverse : ")
	print(afficherChampBataile(joueur: joueurAdverse))
	print("votre main : ")
	print(afficherMain(joueur : joueurActuel))

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
		attaque = true
		attaquer : CarteProtocol
		while(attaque){
	 pouvantAttaquer = joueurActuel.UnitePouvantAttaquer()
         cible = joueurActuel.ciblesDisponible(joueur : joueurAdverse)
			if(cible.count>0 || pouvantAttaquer){
				print(afficherUnite(unite: cible))
				print("Choisir une cible ou arreter l'attaque avec \"stop\"")
				valide = false

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
					changerCible = false
					cibleMorte = false
					unite : [Carte]
					while(changerCible == false || cibleMorte == false){
                        			unite = joueurActuel.unitePouvantAttaquer(carte : attaquer) //ne montrer que les soldats qui sont en mode defensif

						if(unite.count>0){ // Si le joueur possède des cartes capable d'atteindre des cartes ennemis
							print(afficherUnite(unite: unite))
							print("Avec quelle carte voulez vous attaquer ? (tapez la position du soldat dans la liste (commence par 0) ou changer de cible ? (tapez \"changer\")")

							while(!valide){
								if let typed = readLine(){
									if let n = Int(typed){
										input = n
										valide = true
										attaquant = unite[input] //selection d'un attaquant
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
	                                                    print(afficherMain(joueur : joueurActuel))
	                                                    print(joueurAdverse.nom+" veuillez choisir une carte à deployer")
	                                                    
	                                                    joueurAdverse.deployerCarte(carte : joueurAdverse.main.recupererCarte(type: choisirTypeCarte()),x:, y: )
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
		joueurActuel.deployerCarte(carte : joueurActuel.main.recupererCarte(position: choisirTypeCarte()),x:, y: )
		print("carte deployé !")
	}
	tour = tour+1
}

print(joueurGagnant.nom+" est le gagnant de la partie !")
