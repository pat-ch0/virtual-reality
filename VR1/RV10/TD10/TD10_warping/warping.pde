import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;

OpenCV opencv;


//*************************************
// Calcule la transformation entre les coordonnées des points de l'image de départ et de l'image d'arrivée.
// Calcul à partir d'une liste de points et de la taille de template.
// Attention à l'ordre des 4 points !
Mat getPerspectiveTransformation(PVector[] inputPoints, int w, int h) {
  Point[] canonicalPoints = new Point[4];
  canonicalPoints[0] = new Point(w, 0);
  canonicalPoints[1] = new Point(0, 0);
  canonicalPoints[2] = new Point(0, h);
  canonicalPoints[3] = new Point(w, h);

  MatOfPoint2f canonicalMarker = new MatOfPoint2f();
  canonicalMarker.fromArray(canonicalPoints);

  Point[] points = new Point[4];
  for (int i = 0; i < 4; i++) {
    points[i] = new Point(inputPoints[i].x, inputPoints[i].y);
  }
  MatOfPoint2f marker = new MatOfPoint2f(points);
  return Imgproc.getPerspectiveTransform(marker,canonicalMarker);
}

//*************************************
// Calcule la transformation entre les coordonnées des points de l'image de départ et de l'image d'arrivée.
// Calcul à partir de 2 listes de points qui se correspondent
Mat getPerspectiveTransformation(PVector[] inputPoints, PVector[]outputPoints) {
  Point[] inpoints = new Point[4];
  Point[] outpoints = new Point[4];
  for (int i = 0; i < 4; i++) {
    inpoints[i] = new Point(inputPoints[i].x, inputPoints[i].y);
    outpoints[i] = new Point(outputPoints[i].x, outputPoints[i].y);
  }
  MatOfPoint2f outputmarker = new MatOfPoint2f(outpoints);
  MatOfPoint2f inputMarker = new MatOfPoint2f(inpoints);
  return Imgproc.getPerspectiveTransform(inputMarker, outputmarker);
}

//*************************************
// Applique la transformation de l'image opencv vers l'image transformedImage
Mat warpPerspective(PVector[] inputPoints, int w, int h) {
  Mat transform = getPerspectiveTransformation(inputPoints, w, h);
  //println("transform matrix:\n" + transform.dump());    
  Mat transformedImage = new Mat(w, h, CvType.CV_8UC1);  
  Imgproc.warpPerspective(opencv.getColor(), transformedImage, transform, new Size(w,h));
  return transformedImage;
}

//*************************************
// Applique la transformation de l'image opencv vers l'image transformedImage de taille wxh
Mat warpPerspective(Mat transform, int w, int h) {
  Mat transformedImage = new Mat(w, h, CvType.CV_8UC1);    
  Imgproc.warpPerspective(opencv.getColor(), transformedImage, transform, new Size(w,h));
  return transformedImage;
}
