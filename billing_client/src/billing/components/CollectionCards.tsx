import React from 'react';

export type CollectionTotals = {
  saleTotal: number; saleCash: number; saleBank: number;
  dueTotal: number; dueCash: number; dueBank: number;
  totalCash: number; totalBank: number; grandTotal: number;
};

const money = (v?: number) =>
  Number(v || 0).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

type Card = {
  key: string;
  tone: 'sale' | 'due' | 'total';
  icon: string;
  label: string;
  value: number;
  cash: number;
  bank: number;
};

const CollectionCards: React.FC<{ title?: string; data: CollectionTotals }> = ({ title, data }) => {
  const cards: Card[] = [
    { key: 'sale', tone: 'sale', icon: 'fas fa-file-invoice-dollar', label: 'Sale Total', value: data.saleTotal, cash: data.saleCash, bank: data.saleBank },
    { key: 'due', tone: 'due', icon: 'fas fa-hand-holding-dollar', label: 'Due Collection', value: data.dueTotal, cash: data.dueCash, bank: data.dueBank },
    { key: 'total', tone: 'total', icon: 'fas fa-wallet', label: 'Total Cash & Bank', value: data.grandTotal, cash: data.totalCash, bank: data.totalBank },
  ];
  return (
    <div className="st-collect">
      {title ? <div className="st-collect-h">{title}</div> : null}
      <div className="st-collect-grid">
        {cards.map((card) => (
          <article key={card.key} className={`st-col-card ${card.tone}`}>
            <span className="st-col-glow" aria-hidden />
            <i className={`st-col-deco ${card.icon}`} aria-hidden />
            <div className="st-col-top">
              <span className="st-col-ico"><i className={card.icon} /></span>
              <span className="st-col-l">{card.label}</span>
            </div>
            <div className="st-col-v">₹ {money(card.value)}</div>
            <div className="st-col-split">
              <div>
                <em>Cash</em>
                <b>₹ {money(card.cash)}</b>
              </div>
              <div>
                <em>Bank</em>
                <b>₹ {money(card.bank)}</b>
              </div>
            </div>
          </article>
        ))}
      </div>
    </div>
  );
};

export default CollectionCards;
