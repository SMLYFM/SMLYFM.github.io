---
title: 学习时间线
date: 2026-01-25 10:00:00
type: timeline
comments: false
---

<style>
/* 时间线样式 */
.timeline {
  position: relative;
  max-width: 800px;
  margin: 2rem auto;
  padding: 0 20px;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 3px;
  height: 100%;
  background: linear-gradient(180deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  border-radius: 2px;
}

.timeline-item {
  position: relative;
  width: 50%;
  padding: 20px 40px;
  box-sizing: border-box;
}

.timeline-item:nth-child(odd) {
  left: 0;
  text-align: right;
}

.timeline-item:nth-child(even) {
  left: 50%;
  text-align: left;
}

.timeline-item::before {
  content: '';
  position: absolute;
  top: 30px;
  width: 16px;
  height: 16px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: 3px solid white;
  border-radius: 50%;
  box-shadow: 0 3px 10px rgba(102, 126, 234, 0.3);
  z-index: 1;
}

.timeline-item:nth-child(odd)::before {
  right: -8px;
}

.timeline-item:nth-child(even)::before {
  left: -8px;
}

.timeline-content {
  padding: 20px 25px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.timeline-content:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.timeline-date {
  display: inline-block;
  padding: 5px 15px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 12px;
}

.timeline-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin: 0 0 10px;
}

.timeline-desc {
  color: #666;
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0;
}

.timeline-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 12px;
  justify-content: flex-end;
}

.timeline-item:nth-child(even) .timeline-tags {
  justify-content: flex-start;
}

.timeline-tag {
  padding: 3px 10px;
  background: rgba(102, 126, 234, 0.1);
  color: #667eea;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

/* 深色模式 */
[data-theme="dark"] .timeline::before {
  background: linear-gradient(180deg, #79c0ff 0%, #a5d6ff 50%, #d2a8ff 100%);
}

[data-theme="dark"] .timeline-content {
  background: rgba(22, 27, 34, 0.9);
}

[data-theme="dark"] .timeline-title {
  color: #e6edf3;
}

[data-theme="dark"] .timeline-desc {
  color: #8b949e;
}

[data-theme="dark"] .timeline-tag {
  background: rgba(121, 192, 255, 0.15);
  color: #79c0ff;
}

[data-theme="dark"] .timeline-item::before {
  border-color: #1e2329;
}

/* 响应式 */
@media screen and (max-width: 768px) {
  .timeline::before {
    left: 20px;
  }
  
  .timeline-item {
    width: 100%;
    left: 0 !important;
    text-align: left !important;
    padding-left: 50px;
    padding-right: 0;
  }
  
  .timeline-item::before {
    left: 12px !important;
    right: auto !important;
  }
  
  .timeline-tags {
    justify-content: flex-start !important;
  }
}
</style>

# 🗓️ 学习时间线

记录我的学习历程和重要里程碑。

---

<div class="timeline">

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2026.01</span>
    <h3 class="timeline-title">📐 开始深入 PINNs 研究</h3>
    <p class="timeline-desc">探索 Physics-Informed Neural Networks 在偏微分方程求解中的应用，研究神经网络与传统数值方法的结合。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">PINNs</span>
      <span class="timeline-tag">PyTorch</span>
      <span class="timeline-tag">PDE</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2025.09</span>
    <h3 class="timeline-title">🦀 学习 Rust 编程语言</h3>
    <p class="timeline-desc">开始学习 Rust，深入理解所有权系统、生命周期和内存安全机制。用 Rust 重写了部分数值计算代码。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">Rust</span>
      <span class="timeline-tag">系统编程</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2025.06</span>
    <h3 class="timeline-title">🧮 泛函分析学习</h3>
    <p class="timeline-desc">系统学习泛函分析，包括 Banach 空间、Hilbert 空间和算子理论。为理解 PDE 的弱解理论打下基础。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">泛函分析</span>
      <span class="timeline-tag">数学</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2025.03</span>
    <h3 class="timeline-title">🔥 深入学习 PyTorch</h3>
    <p class="timeline-desc">掌握 PyTorch 的自动微分机制、自定义层和分布式训练。开始参与深度学习项目开发。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">PyTorch</span>
      <span class="timeline-tag">深度学习</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2024.12</span>
    <h3 class="timeline-title">📝 LaTeX 进阶</h3>
    <p class="timeline-desc">学习 LaTeX 高级排版技巧，包括 TikZ 绘图、自定义宏包开发和学术论文模板制作。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">LaTeX</span>
      <span class="timeline-tag">学术写作</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2024.09</span>
    <h3 class="timeline-title">📊 偏微分方程数值方法</h3>
    <p class="timeline-desc">学习有限差分、有限元和谱方法求解 PDE。使用 Python 实现各种数值格式。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">PDE</span>
      <span class="timeline-tag">数值分析</span>
      <span class="timeline-tag">Python</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2024.06</span>
    <h3 class="timeline-title">🎓 开始研究生学习</h3>
    <p class="timeline-desc">正式开始数学专业的研究生学习，专注于偏微分方程和科学计算方向。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">数学</span>
      <span class="timeline-tag">研究生</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2024.01</span>
    <h3 class="timeline-title">🐍 Python 科学计算</h3>
    <p class="timeline-desc">系统学习 NumPy、SciPy、Matplotlib 等科学计算库，开始用 Python 进行数学建模。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">Python</span>
      <span class="timeline-tag">NumPy</span>
      <span class="timeline-tag">科学计算</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2023.09</span>
    <h3 class="timeline-title">📖 实分析入门</h3>
    <p class="timeline-desc">开始学习实分析，使用 Ruerta 和 Abbott 的教材。理解极限、连续、可微和可积的严格定义。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">实分析</span>
      <span class="timeline-tag">数学</span>
    </div>
  </div>
</div>

<div class="timeline-item">
  <div class="timeline-content">
    <span class="timeline-date">2023.03</span>
    <h3 class="timeline-title">🌐 创建个人博客</h3>
    <p class="timeline-desc">使用 Hexo + Butterfly 主题搭建个人博客，开始记录学习笔记和技术分享。</p>
    <div class="timeline-tags">
      <span class="timeline-tag">Hexo</span>
      <span class="timeline-tag">博客</span>
    </div>
  </div>
</div>

</div>

---

<div style="text-align: center; margin-top: 2rem; color: #888;">
  <p>🚀 旅程还在继续...</p>
</div>
