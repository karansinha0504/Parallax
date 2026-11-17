(function(){
if(typeof gHero!=='function'||typeof gItems!=='function')return;
let cand=[],hi=0,tm=null,busy=false;
const grid=()=>document.getElementById('pGrid');
function build(){const it=gItems();const part=[],next=[];it.forEach((x,i)=>{if(x.p>0&&x.p<1)part.push(i);else if(!x.p&&!x.w)next.push(i)});
  cand=part.concat(next.slice(0,5));if(!cand.length)cand=it.slice(0,5).map((_,i)=>i);}
function paint(){
  const it=gItems();if(!cand.length){const I=document.getElementById('lgI');if(I)I.innerHTML='<div class="pT">Nothing here yet</div>';return}
  const idx=cand[hi%cand.length],x=it[idx],I=document.getElementById('lgI');if(!x||!I)return;gSel=idx;lArt(x.k,'lg');
  const isS=GP.type==='s',cont=x.p>0&&x.p<1;
  I.innerHTML=`<div class="pS mut">${cont?'Continue watching':'Suggested for you'}</div><div class="pT">${x.t}</div><div class="pS mut">${[x.g,x.y,x.d].filter(Boolean).join(', ')}${x.tm?', TMDB '+x.tm:''}</div><div class="pS clamp2" style="opacity:.85">${x.s||''}</div><div class="lbtns"><div class="lbtn pgb" data-gplay="1">${I_.play}<span>${isS?'Resume S2 E4':cont?'Resume':'Play'}</span></div><div class="lbtn pg2" data-gdet="1">${I_.info}<span>Details</span></div></div>`;
}
const I_=window.I||(typeof I!=='undefined'?I:{});
function swap(){const el=document.getElementById('lgI');if(!el){paint();return}el.style.opacity=0;setTimeout(()=>{paint();el.style.opacity=1},280)}
function start(){clearInterval(tm);if(cand.length<2)return;tm=setInterval(()=>{const g=grid();if(!g||!g.classList.contains('on')||document.hidden)return;hi=(hi+1)%cand.length;swap()},6500)}
window.gHero=function(){build();hi=0;const el=document.getElementById('lgI');if(el)el.style.opacity=1;paint();start()};
})();
