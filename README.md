# Image Filtering & Hough Transform — MATLAB Edge Detection & Line Finding

Takes a photo and automatically finds all the straight lines in it — edges of roads, buildings, tables, or any other structure. It works by first sharpening the edges in the image, then using a mathematical voting technique called the Hough Transform to identify which lines best explain those edges.

Built from scratch in MATLAB without using built-in image processing functions. The pipeline implements zero-padded 2D convolution, Gaussian smoothing, Sobel gradient with non-maximum suppression for edge thinning, Hough accumulator voting in (ρ, θ) space, NMS-based peak extraction for the top-N dominant lines, and an extra credit extension that converts infinite Hough lines into finite segments with configurable gap tolerance. Batch-processed across 9 test images.

**[Live Demo →](https://halkhoori2000.github.io/Image-Filtering-and-Hough-Transform/)**

## Use Cases
- Autonomous vehicle lane detection: road markings are straight lines detectable with Hough even under varying lighting and shadows
- Document scanning and skew correction: dominant line orientation reveals page rotation, enabling automatic straightening
- Industrial inspection: detecting edges of machined parts, PCB traces, or structural elements to verify alignment and dimensions
- Medical imaging: identifying straight anatomical structures such as bone boundaries or surgical instrument shafts in X-ray and fluoroscopy images

## Challenges
- **NMS orientation quantisation**: gradient direction must be quantised to one of four orientations (0°, 45°, 90°, 135°) and pixels must be suppressed if they are not local maxima along that direction — an off-by-one in the direction mapping produces thick multi-pixel edges that flood the Hough accumulator with duplicate votes for the same line
- **Hough accumulator resolution tradeoff**: coarse ρ and θ resolution speeds up computation but merges nearby parallel lines into a single peak; fine resolution creates a sparse accumulator where votes scatter across neighbouring bins rather than concentrating — the chosen values (ρ=2px, θ=π/90) balance sensitivity against runtime across all 9 test images
- **Peak isolation in cluttered accumulator space**: dominant lines produce broad vote clusters; without a second round of NMS on the accumulator itself, the top-N extraction repeatedly selects neighbouring bins of the same line rather than N distinct lines, collapsing the output to a single dominant direction

---

## Features

- **Custom 2D convolution** — zero-padded kernel convolution from scratch (`myImageFilter`)
- **Edge detection** — Gaussian blur → Sobel gradient → non-maximum suppression along gradient direction
- **Hough Transform** — accumulator-based (ρ, θ) voting for every edge pixel above threshold
- **Peak extraction** — NMS on accumulator + sorted peak retrieval for top-N dominant lines
- **Line segment detection** — extra credit: converts infinite Hough lines to finite segments with gap tolerance
- **Batch processing** — runs the full pipeline on 9 test images, saving all intermediate outputs

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | MATLAB |
| Core techniques | 2D convolution, Gaussian filter, Sobel operator, NMS, Hough Transform |
| Build | MATLAB script (no toolboxes except `fspecial` and `houghlines` for final rendering) |
| Platform | MATLAB |

---

## Pipeline

```
Input Image (grayscale)
      │
      ▼
 myImageFilter ← Gaussian kernel (σ=2)
      │  Gaussian smoothing
      ▼
 myEdgeFilter  ← Sobel Gx, Gy → gradient magnitude + angle
      │  Non-maximum suppression (NMS)
      ▼
 Threshold     ← binary edge map (t=0.3)
      │
      ▼
 myHoughTransform ← votes (ρ, θ) per edge pixel
      │  Accumulator matrix H[ρ, θ]
      ▼
 myHoughLines  ← NMS on H, extract top-50 peaks
      │
      ▼
 Detected Lines overlaid on original image
```

**Parameters:**
- σ = 2 (Gaussian blur)
- threshold = 0.3 (edge binarisation)
- ρ resolution = 2 px
- θ resolution = π/90 rad (~2°)
- nLines = 50 (lines extracted)

---

## Project Structure

```
Image-Filtering-and-Hough-Transform/
├── src/
│   ├── myImageFilter.m       ← zero-padded 2D convolution
│   ├── myEdgeFilter.m        ← Gaussian + Sobel + NMS edge detector
│   ├── myHoughTransform.m    ← (ρ, θ) accumulator
│   ├── myHoughLines.m        ← NMS on accumulator + peak extraction
│   ├── myHoughLineSegments.m ← EC: finite line segment detection
│   ├── drawLine.m            ← utility: draw line on image
│   ├── houghScript.m         ← main batch processing script
│   └── ec.m                  ← EC driver script
├── data/                     ← input images (img01–img09.jpg)
├── results/                  ← pipeline outputs (edge, threshold, hough, lines)
├── ec/                       ← extra credit images and results
└── index.html                ← interactive pipeline demo (GitHub Pages)
```

---

## Run

**Requirements:** MATLAB

```matlab
% From MATLAB, navigate to src/
cd src
houghScript   % runs full pipeline on data/ → outputs saved to results/
```

---

## Course

CMPEN 454 — Fundamentals of Computer Vision  
The Pennsylvania State University
