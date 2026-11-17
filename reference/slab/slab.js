(function(){
const IS_TV=!!document.getElementById('tv')&&!!document.getElementById('tHome');
const root=document.getElementById(IS_TV?'tv':'ph');if(!root)return;
const q=new URLSearchParams(location.search);
document.body.classList.toggle('gs',q.get('focus')!=='cur');
/* switch UI */
if(!IS_TV){document.body.classList.add('gs');return}
const bar=document.createElement('div');bar.className='gsbar';
bar.innerHTML='<span>Focus</span><button data-m="gs">Glass slab</button><button data-m="cur">Current</button>';
const host=document.querySelector(IS_TV?'.tvhold':'.phwrap');host.parentNode.insertBefore(bar,host);
function setM(m){document.body.classList.toggle('gs',m==='gs');bar.querySelectorAll('button').forEach(b=>b.classList.toggle('on',b.dataset.m===m))}
bar.querySelectorAll('button').forEach(b=>b.onclick=()=>setM(b.dataset.m));setM(document.body.classList.contains('gs')?'gs':'cur');
window.addEventListener('keydown',e=>{if(e.key==='g'||e.key==='G')setM(document.body.classList.contains('gs')?'cur':'gs')});
/* elements */
const slab=document.createElement('div');slab.className='gslab';
slab.innerHTML='<div class="ed"><div class="edi"></div></div><div class="rg"></div><div class="in"></div><div class="sp"></div><div class="bv"></div>';
root.appendChild(slab);
const ruler=document.createElement('div');ruler.style.cssText='position:absolute;left:0;top:0;width:100px;height:1px;visibility:hidden;pointer-events:none';root.appendChild(ruler);
const edi=slab.querySelector('.edi');
const $=s=>document.querySelector(s);
function visible(sel){const e=$(sel);return !!e&&e.classList.contains('on')}
/* ---- target finders ---- */
function find(){
  if(IS_TV){
    if(visible('#tLauncher')){const e=$('#tLauncher .zd .app.on')||$('#tLauncher .k3.f');if(e)return{el:e,clip:$('#tLauncher'),fade:$('#tLauncher')};return null}
    if(visible('#tShow')){const e=$('#s5G .p5.f .im');if(e)return{el:e,clip:$('#tShow'),fade:$('#tShow')};return null}
    if(typeof topF!=='undefined'&&topF)return null;
    if(visible('#tHome')){
      const lb=$('#secs .lib.foc');if(lb)return{el:lb,clip:$('#tHome'),fade:lb.closest('.sec')||lb};
      const sec=$('#secs .sec.open');if(!sec)return null;
      const c=sec.querySelector('.rc.popf');if(!c)return null;
      return{el:c.classList.contains('stack')?(c.querySelector('.k3x')||c):c,clip:sec,fade:sec};
    }
    if(visible('#tGrid')){const e=$('#g5G .p5.f .im');if(!e)return null;return{el:e,clip:$('#tGrid'),fade:$('#g5W')}}
    return null;
  }
  if(visible('#pHome')){
    {const lb=document.querySelector('#psecs .psec.open .pl2.on');if(lb){const bx=$('#psecs');return{el:lb,clip:bx,fade:lb.closest('.psec'),drag:bx}}}
    const box=$('#psecs');const sec=box&&box.querySelector('.psec.open');if(!sec)return null;
    const c=sec.querySelector('.prc2.popf');if(!c)return null;
    return{el:c.classList.contains('stk')?(c.querySelector('.k3x')||c):c,clip:box,fade:sec,drag:box};
  }
  {const e=$('#lgG .ppo.sel .pi');if(!e||!e.closest('.ps.on'))return null;return{el:e,clip:$('#lgG'),fade:$('#lgG')}}
  return null;
}
/* ---- engine (only runs while something is moving) ---- */
let hideUntil=0,lastClip=null,fz=0,cur=null,S=null,V={x:0,y:0,w:0,h:0},travel=false,last=performance.now(),restTop=null,activeUntil=0,kCache=1,kAt=0,clipCache=null,clipEl=null,clipAt=0;
const W={};function setS(p,v){if(W[p]!==v){W[p]=v;slab.style[p]=v}}
function wake(ms){const t=performance.now()+(ms||1000);if(t>activeUntil)activeUntil=t}
['pointerdown','pointermove','pointerup','keydown','click','wheel','touchmove','touchend'].forEach(e=>window.addEventListener(e,()=>wake(1400),{passive:true,capture:true}));
root.addEventListener('transitionrun',()=>wake(800),true);root.addEventListener('animationstart',()=>wake(800),true);document.addEventListener('scroll',()=>wake(700),true);
new MutationObserver(rs=>{for(const r of rs){if(slab.contains(r.target))continue;wake(900);break}}).observe(root,{attributes:true,attributeFilter:['class'],subtree:true});
let RC=null;const radCache={};let rootGc='',rootGcAt=0;
function kk(now){if(now-kAt>400||!RC){kCache=ruler.getBoundingClientRect().width/100||1;RC=root.getBoundingClientRect();kAt=now}return kCache}

/* where moving ancestors (row/grid scroll) are headed, so the slab can glide straight to the final spot instead of chasing a sliding card */
function pend(el,k){let dx=0,dy=0;const cq=root.offsetWidth/100;
  for(let a=el.parentElement;a&&a!==root;a=a.parentElement){
    const t=a.style&&a.style.transform;if(!t)continue;
    let an;try{an=a.getAnimations()}catch(e){an=[]}if(!an.length)continue;
    const m=new DOMMatrix(getComputedStyle(a).transform);let ex=0,ey=0;
    const mx=/translateX\((-?[\d.]+)(px|cqw)/.exec(t),my=/translateY\((-?[\d.]+)(px|cqw)/.exec(t);
    if(mx)ex=parseFloat(mx[1])*(mx[2]==='cqw'?cq:1);if(my)ey=parseFloat(my[1])*(my[2]==='cqw'?cq:1);
    dx+=ex-m.m41;dy+=ey-m.m42}
  return[dx,dy]}
function step(now){
  requestAnimationFrame(step);
  const dt=Math.min(.033,(now-last)/1000);last=now;
  if(!document.body.classList.contains('gs')||window.__noeng)return;
  if(now>activeUntil&&!travel)return;
  const t=find();
  if(!t){slab.classList.remove('on');cur=null;return}
  if(t.drag&&t.drag.classList.contains('drag')&&cur===t.el&&S&&(fz++%4)!==0)return;
  const k=kk(now),R=RC,r=t.el.getBoundingClientRect();
  if(!r.width||!r.height){slab.classList.remove('on');return}
  let tx=(r.left-R.left)/k,ty=(r.top-R.top)/k,tw=r.width/k,th=r.height/k;
  let faded=false;
  if(t.drag&&t.drag.classList.contains('drag')&&cur===t.el&&S){
    if(restTop===null)restTop=S.y;
    if(Math.abs(ty-restTop)>5)faded=true;
    tx=S.x;ty=S.y;tw=S.w;th=S.h;
  }else restTop=null;
  if(travel&&cur===t.el){const[px,py]=pend(t.el,k);tx+=px;ty+=py}
  if(!S){S={x:tx,y:ty,w:tw,h:th};V={x:0,y:0,w:0,h:0};travel=false}
  if(cur!==t.el){
    cur=t.el;travel=slab.classList.contains('on');
    if(lastClip&&t.clip!==lastClip&&IS_TV){travel=false;hideUntil=now+480;wake(900)}
    const key=t.el.className.replace(/\b(popf|foc|f|sel|on)\b/g,'').trim();
    let rad=radCache[key];if(rad===undefined){rad=parseFloat(getComputedStyle(t.el).borderTopLeftRadius)||12;radCache[key]=rad}
    slab.style.setProperty('--gr',rad+'px');
    if(now-rootGcAt>1500){rootGc=getComputedStyle(root).getPropertyValue('--gc').trim();rootGcAt=now}
    const own=(t.el.closest('[style*="--gc"]')||{style:{getPropertyValue:()=>''}}).style.getPropertyValue('--gc').trim();
    const m=/img-([a-z]+)/.exec(t.el.className),tab=typeof GC!=='undefined'?GC:(typeof PGC!=='undefined'?PGC:null);
    slab.style.setProperty('--gc',own||(m&&tab&&tab[m[1]])||rootGc||'rgba(255,255,255,.15)');
    V={x:0,y:0,w:0,h:0};clipEl=null;
  }
  if(travel){
    const sp=(p,v,T,K,C)=>{const a=K*(T-p)-C*v;v+=a*dt;return[p+v*dt,v]};
    [S.x,V.x]=sp(S.x,V.x,tx,200,28.3);[S.w,V.w]=sp(S.w,V.w,tw,200,28.3);
    [S.y,V.y]=sp(S.y,V.y,ty,170,26);[S.h,V.h]=sp(S.h,V.h,th,170,26);
    if(Math.abs(S.x-tx)+Math.abs(S.y-ty)+Math.abs(S.w-tw)+Math.abs(S.h-th)<.6&&Math.abs(V.x)+Math.abs(V.y)<8)travel=false;
  }else{S.x=tx;S.y=ty;S.w=tw;S.h=th}
  setS('width',S.w.toFixed(1)+'px');setS('height',S.h.toFixed(1)+'px');
  setS('transform',`translate3d(${S.x.toFixed(1)}px,${S.y.toFixed(1)}px,0)`);
  if(clipEl!==t.clip||now-clipAt>250){clipEl=t.clip;clipAt=now;const c=t.clip.getBoundingClientRect();clipCache={t:(c.top-R.top)/k,l:(c.left-R.left)/k,b:(c.bottom-R.top)/k,r:(c.right-R.left)/k}}
  const ov=80,C=clipCache;
  const iT=C.t-S.y,iL=C.l-S.x,iB=S.y+S.h-C.b,iR=S.x+S.w-C.r;
  setS('clipPath',`inset(${iT>0?iT.toFixed(1):-ov}px ${iR>0?iR.toFixed(1):-ov}px ${iB>0?iB.toFixed(1):-ov}px ${iL>0?iL.toFixed(1):-ov}px)`);
  const fo=parseFloat(t.fade.style.opacity);
  lastClip=t.clip;
  slab.classList.toggle('on',!faded&&now>hideUntil&&(isNaN(fo)||fo>.5));
}
requestAnimationFrame(step);
window.__slab={find,S:()=>S};
})();
