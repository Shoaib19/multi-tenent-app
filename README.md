<h1>🏛️ Multi Tenent Spaces App</h1>

<p>
  A web platform for <strong>organizations</strong> to manage online spaces with robust <strong>age verification</strong> and <strong>parental consent</strong> features.
</p>

<p>
  Admins and moderators can create, manage, and moderate spaces for different age groups (Child, Teen, Adult). Users can join spaces appropriate for their age, with parental consent required where needed.
</p>

<h2>✨ Features</h2>
<ul>
  <li>✅ User authentication with role-based access (Admin, Moderator, User)</li>
  <li>✅ Age group management (Child, Teen, Adult)</li>
  <li>✅ Parental consent flows for underage users</li>
  <li>✅ Organizations with customizable spaces</li>
  <li>✅ Admin dashboard with analytics</li>
  <li>✅ Responsive design with easy theming</li>
</ul>

<hr>

<h2>🐳 Running with Docker</h2>
<p>
  This project includes a <strong>Docker</strong> setup with:
</p>
<ul>
  <li>A Rails server container</li>
  <li>A PostgreSQL database container</li>
</ul>
<p>
  You can run the entire app locally without installing Ruby, Rails, or PostgreSQL on your host machine.
</p>

<hr>

<h2>⚡ Prerequisites</h2>
<ul>
  <li>Docker (<a href="https://docs.docker.com/get-docker/">Get Docker</a>)</li>
  <li>Docker Compose (comes with Docker Desktop)</li>
</ul>

<hr>

<h2>🚀 Setup Steps</h2>

<h3>1️⃣ Build the containers</h3>
<pre><code>docker compose build</code></pre>
<p>This step installs all dependencies in your Rails image.</p>

<h3>2️⃣ Start the services</h3>
<pre><code>docker compose up -d</code></pre>
<p>This will:</p>
<ul>
  <li>Start the Rails server on <code>localhost:3000</code></li>
  <li>Start PostgreSQL and link it to Rails</li>
</ul>

<h3>3️⃣ Create the database</h3>
<pre><code>docker compose run web bundle exec rails db:create</code></pre>
<p>This creates the PostgreSQL database inside the container.</p>

<h3>4️⃣ Run migrations</h3>
<pre><code>docker compose run web bundle exec rails db:migrate</code></pre>

<h3>5️⃣ Seed the database</h3>
<pre><code>docker compose run web bundle exec rails db:seed</code></pre>
<p>This seeds:</p>
<ul>
  <li>Default organizations</li>
  <li>Age groups (Child, Teen, Adult)</li>
  <li>Admins, moderators, and users for testing</li>
  <li>Spaces with proper age requirements</li>
</ul>

<h3>6️⃣ Visit the app</h3>
<p>After seeding, your app is ready! Open your browser at:</p>
<pre><code>http://localhost:3000</code></pre>
<p>Login with seeded first Org admin account:</p>
<pre><code>Email: admin@alpha.org
Password: password</code></pre>
<p>or use second Org admin user</p>
<pre><code>Email: admin@beta.org
Password: password</code></pre>

<hr>

<h2>🛠️ Example Admin Features</h2>
<ul>
  <li>Manage users (assign roles, activate/deactivate)</li>
  <li>Create, edit, and remove spaces</li>
  <li>View analytics dashboard with user and space stats</li>
  <li>Enforce age group rules</li>
  <li>Handle parental consent approvals</li>
</ul>

<hr>
