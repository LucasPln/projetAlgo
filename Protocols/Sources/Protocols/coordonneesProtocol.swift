// Type Coordonnees est un couple de coodonnées servant à definir la portée d'attaque d'une carte
public protocol CoordonneesProtocol {
    // init : Int x Int
    // Création d'un couple de coordonnées x et y relative par rapport aux joueurs

    init(x : Int, y : Int)
}
