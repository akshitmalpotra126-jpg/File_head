<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cinematic WebGL Landing Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background: #000;
            color: #fff;
            overflow-x: hidden;
        }
        #canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        .section {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
        }
        .title {
            font-size: 4rem;
            font-weight: 300;
            opacity: 0;
            transform: translateY(50px);
        }
        .subtitle {
            font-size: 2rem;
            font-weight: 200;
            opacity: 0;
            transform: translateY(50px);
        }
        @media (max-width: 768px) {
            .title {
                font-size: 2rem;
            }
            .subtitle {
                font-size: 1.5rem;
            }
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.9.1/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.9.1/ScrollTrigger.min.js"></script>
</head>
<body>
    <canvas id="canvas"></canvas>
    <div class="section">
        <div>
            <h1 class="title">Innovate</h1>
            <p class="subtitle">Experience the future</p>
        </div>
    </div>
    <div class="section">
        <div>
            <h1 class="title">Design</h1>
            <p class="subtitle">Crafted with precision</p>
        </div>
    </div>
    <div class="section">
        <div>
            <h1 class="title">Explore</h1>
            <p class="subtitle">Beyond imagination</p>
        </div>
    </div>

    <script>
        // Three.js setup
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('canvas'), antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setClearColor(0x000000, 1);

        // Create a floating 3D object (torus as a simple example, like a futuristic ring)
        const geometry = new THREE.TorusGeometry(1, 0.4, 16, 100);
        const material = new THREE.MeshStandardMaterial({ color: 0xffffff, metalness: 0.8, roughness: 0.2 });
        const torus = new THREE.Mesh(geometry, material);
        scene.add(torus);

        // Lighting
        const ambientLight = new THREE.AmbientLight(0x404040, 0.5);
        scene.add(ambientLight);
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
        directionalLight.position.set(5, 5, 5);
        scene.add(directionalLight);

        // Camera initial position
        camera.position.z = 5;

        // Animation loop
        function animate() {
            requestAnimationFrame(animate);
            torus.rotation.x += 0.01;
            torus.rotation.y += 0.01;
            renderer.render(scene, camera);
        }
        animate();

        // GSAP ScrollTrigger for camera animation
        gsap.registerPlugin(ScrollTrigger);

        gsap.to(camera.position, {
            z: 2,
            scrollTrigger: {
                trigger: ".section:nth-child(2)",
                start: "top bottom",
                end: "bottom top",
                scrub: true
            }
        });

        gsap.to(camera.position, {
            z: 1,
            scrollTrigger: {
                trigger: ".section:nth-child(3)",
                start: "top bottom",
                end: "bottom top",
                scrub: true
            }
        });

        // Kinetic typography animations
        gsap.utils.toArray(".title").forEach((title, i) => {
            gsap.to(title, {
                opacity: 1,
                y: 0,
                duration: 1,
                scrollTrigger: {
                    trigger: title,
                    start: "top 80%",
                    end: "bottom 20%",
                    toggleActions: "play none none reverse"
                }
            });
        });

        gsap.utils.toArray(".subtitle").forEach((subtitle, i) => {
            gsap.to(subtitle, {
                opacity: 1,
                y: 0,
                duration: 1,
                delay: 0.5,
                scrollTrigger: {
                    trigger: subtitle,
                    start: "top 80%",
                    end: "bottom 20%",
                    toggleActions: "play none none reverse"
                }
            });
        });

        // Handle window resize
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });
    </script>
</body>
</html>
