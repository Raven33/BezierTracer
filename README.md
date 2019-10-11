# BezierTracer
Information générales:

Ce programme à pour but de permetre de dessiner facilement des courbe de Bézier dans Processing.
Ce programme exporte automatiquement la/les forme.s crée.s dans un fichier texte (output_code.txt) dans le dossier du sketch.

Installation:
allez dans:
Sketch>ajouter un fichier ...
puis sélectionner le fichier BezierTracer.pde
Enfin, appelez la fonction bezierTracer() dans le draw de votre sketch.
Passer en paramètre de cette fonction: true si vous souhaitez que la fonction actualise le background d'elle même, et false si vous souhaitez gérer le background vous même.

Utilisation:
Les touches et leurs correspondances:
N -> nouveau point aux coordonnées de la souris.
B -> nouvelle courbe de Bézier entre le point précédent et la position de la souris.
E -> balise endShape(). (finis la forme)
R -> Supprime tous les points. (/!\ cette commande vous fait perdre tous ce que vous avez dessiner /!\)

Roadmap:
- Message d'alerte dans la console lors d'erreur type bezierVertex avant vertex (au lieu de planter)
- Suppression individuelle de point
- ...