# Video-Denoising-by-Kalman-Filtering-Technique
Description - Video denoising using Kalman and Wiener filters with PSNR, SSIM and MSE evaluation in MATLAB

📌 Introduction

Video denoising is a fundamental problem in digital signal and image processing. Video signals are often degraded by noise during acquisition, transmission, or compression. This noise reduces visual quality and affects further processing tasks such as object detection, tracking, and recognition.

Traditional filtering methods such as Wiener filtering are effective for reducing Gaussian noise but fail to preserve temporal consistency across video frames. This project focuses on implementing and analyzing **Kalman filtering**, a recursive estimation technique that utilizes both spatial and temporal information for improved video denoising.

🎯 Objectives

* To simulate noisy video conditions by adding noise to input video sequences
* To implement Wiener filtering for spatial noise reduction
* To implement Kalman filtering for temporal noise reduction
* To evaluate performance using quantitative metrics:

  * Peak Signal-to-Noise Ratio (PSNR)
  * Structural Similarity Index (SSIM)
  * Mean Squared Error (MSE)
* To compare the effectiveness of Wiener and Kalman filters


❗ Problem Statement

Video denoising is challenging due to the presence of noise and the dynamic nature of video sequences.

The Wiener filter:

* Operates on individual frames
* Does not use temporal information
* Causes blurring and loss of fine details at high noise levels

To overcome these limitations, the Kalman filter is used as a recursive estimator that:

* Models video as a dynamic system
* Uses prediction and correction mechanisms
* Maintains temporal consistency across frames



⚙️ Methodology

🔹 System Design

The system performs denoising using both spatial and temporal filtering techniques:

1. **Input Video Acquisition**

   * Video is loaded using MATLAB (`VideoReader`)
   * Frames are extracted for processing

2. **Noise Addition**

   * Noise is artificially added to simulate real-world conditions
   * Types of noise:

     * Gaussian Noise
     * Salt & Pepper Noise

3. **Denoising Techniques**

** ➤ Wiener Filter**

* Linear spatial filter
* Minimizes mean squared error
* Applied frame-by-frame
* Limitation: does not consider temporal information

**➤ Kalman Filter**

* Recursive estimation algorithm
* Uses prediction and correction steps
* Exploits temporal correlation between frames
* Preserves motion and fine details

4. **Performance Evaluation**
   Metrics used:

   * **MSE (Mean Squared Error)** → Lower is better
   * **PSNR (Peak Signal-to-Noise Ratio)** → Higher is better
   * **SSIM (Structural Similarity Index)** → Closer to 1 is better

5. **Output Generation**

   * Frame-by-frame comparison is displayed
   * Output video is generated with annotations

🧠 Kalman Filter Working Principle

The Kalman filter operates in two steps:

# 1. Prediction Step

* Predicts the current frame using previous frame data

# 2. Update (Correction) Step

* Updates prediction using noisy observation
* Computes Kalman Gain to balance prediction and measurement

This recursive approach allows the filter to adapt dynamically and improve estimation accuracy.

---

# 📊 Results

### 🔹 Experiment 1 (50 Frames)

| Filter        | PSNR (dB) | SSIM   | MSE      |
| ------------- | --------- | ------ | -------- |
| Kalman Filter | 30.7490   | 0.9136 | 0.000847 |
| Wiener Filter | 29.3347   | 0.8988 | 0.001166 |

---

# 🔹 Experiment 2 (moon.avi)

**Kalman Filter:**

* PSNR: 36.9670 dB
* SSIM: 0.8993
* MSE: 0.000693

**Wiener Filter:**

* PSNR: 19.3897 dB
* SSIM: 0.1651
* MSE: 0.011509

---

# 🔹 Observations

* Kalman filter consistently achieves:

  * Higher PSNR
  * Higher SSIM
  * Lower MSE
* Produces smoother and more visually accurate results
* Maintains temporal consistency across frames

---

# 📁 Project Structure

```
video-denoising-kalman-filter/
│
├── code/        # MATLAB implementation
├── data/        # Input video files
├── results/     # Output images and videos
├── docs/        # Sample outputs and documentation
├── report/      # Mini project report
├── README.md
└── LICENSE
```

---

## ▶️ How to Run

1. Open MATLAB
2. Navigate to the project folder
3. Place input video (e.g., `moon.avi`) in the correct directory
4. Run:

```
main.m
```

5. Enter number of frames to process

---

## 💡 Applications

* Surveillance and security systems
* Medical imaging (ultrasound, MRI)
* Satellite and remote sensing
* Video streaming and conferencing
* Autonomous navigation systems

---

## ⚖️ Advantages and Limitations

### ✅ Advantages of Kalman Filter

* Utilizes temporal information
* Adaptive and dynamic
* Preserves motion and edges
* Suitable for real-time applications

### ❌ Limitations

* Requires proper tuning of parameters (Q and R)
* Computationally more complex than Wiener filter
* Assumes linear system behavior

---

## 🏆 Conclusion

This project demonstrates that:

* Wiener filtering is effective for basic noise reduction but suffers from blurring and lack of temporal consistency
* Kalman filtering provides superior performance by leveraging temporal correlation
* Experimental results show improved PSNR, SSIM, and MSE using Kalman filtering

Thus, **Kalman filtering is a more reliable and efficient technique for video denoising in real-time applications**.

---

## 📚 References

1. Kavitha, L. S. M. C. – Kalman Filtering Technique for Video Denoising
2. IEEE Transactions on Signal Processing
3. Various research papers on image and video denoising

---

## 👩‍💻 Author

**Lakumalla Pallavi**
M.Tech – Systems and Signal Processing
JNTUH University College of Engineering
