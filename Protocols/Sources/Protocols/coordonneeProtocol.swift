// Coordonnee (0,0) correspond à la position F1
// Type Coordonnees est un couple de coodonnées représentant la position de la carte sur un champ de bataille
public protocol CoordonneeProtocol {
    // init : Int x Int
    // Création d'un couple de coordonnées x et y
    init(x : Int, y : Int)

    positionX()->Int
    positionY()->Int

    //retournerCarte : ->Carte ?
    //retourn la carte associé à la coordonné, retourne vide si il y en a pas
    func retournerCarte()->Carte?

}
