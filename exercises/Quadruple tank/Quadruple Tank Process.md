# **Building the Model**

Physical models are based on conservation principles:
1. Mass
2. Energy
3. Momentum

The general derivation of the system of equations have the form 

$$\text{Accumulated = influx } - \text{ Outflux }+ (\underset{\text{(Generated)}}{\text{Produced }-\text{ Consumed}})$$
For non-reactive systems, the generation term is absent
$$\text{Accumulated} = \text{Influx}-\text{Outflux}$$
## **The 4-Tank System**

![[Pasted image 20240909080314.png|center|500]]


### **Tank 1**

$$\text{Accumulated} = \text{Influx}-\text{Outflux}$$
with,
$$\begin{align}
\text{Accumulated} &= m_{1}(t+\Delta t)-m_{1}\left( t \right) \\
\text{Influx} &= \rho q_{1, in}\left( t \right) \Delta t + \rho q_{3}\left( t \right) \Delta t \\
\text{Outflux} &= \rho q_{1}\left( t \right) \Delta t
\end{align}$$
Therefore, 
$$ \begin{align}
m_{1}(t+\Delta t)-m_{1}\left( t \right) &= \rho q_{1, in}\left( t \right) \Delta t + \rho q_{3}\left( t \right) \Delta t - \rho q_{1}\left( t \right) \Delta t \\
&= \rho \Delta t \left( q_{1, in}\left( t \right)  +  q_{3}\left( t \right) - q_{1}\left( t \right) \right) \\
\implies \frac{m_{1}(t+\Delta t)-m_{1}\left( t \right)}{\Delta t} &= \rho \left( q_{1, in}\left( t \right)  +  q_{3}\left( t \right) - q_{1}\left( t \right) \right)
\end{align}$$
Let $\Delta t \rightarrow 0$ 
$$\frac{d m_{1} \left( t \right)}{d t} = \rho \left( q_{1, in}\left( t \right)  +  q_{3}\left( t \right) - q_{1}\left( t \right) \right)$$
**Overview of process:**
1. Conservation of mass.
2. Division by $\Delta t$
3. Taking the limit ($\Delta t \rightarrow 0$, i.e., differentiation from first principles).

## **Entire System**

**Mass Balances:**
$$\begin{align}
\frac{d m_{1} \left( t \right)}{d t} &= \rho \left( q_{1, in}\left( t \right)  +  q_{3}\left( t \right) - q_{1}\left( t \right) \right), \quad m_{1}\left( t_{0} \right)=m_{1,0}\\
\frac{d m_{2} \left( t \right)}{d t} &= \rho \left( q_{2,in} (t) + q_{4} (t) - \rho q_{2}(t) \right), \quad m_{2}\left( t_{0} \right)=m_{2,0} \\
\frac{d m_{3} \left( t \right)}{d t} &= \rho \left( q_{3, in}\left( t \right) - q_{3}\left( t \right) \right), \quad m_{3}\left( t_{0} \right)=m_{3,0} \\
\frac{d m_{4} \left( t \right)}{d t} &= \rho \left( q_{4, in}\left( t \right) - q_{4}\left( t \right) \right), \quad m_{4}\left( t_{0} \right)=m_{4,0}
\end{align}$$
**Inflows:**
$$\begin{align}
q_{1, in}(t) &= \gamma_{1}F_{1}(t), \quad q_{2, in}(t) = \gamma_{2}F_{2}(t) \\
q_{1, in}(t) &= (1-\gamma_{2})F_{2}(t), \quad q_{2, in}(t) = (1-\gamma_{1})F_{1}(t) 
\end{align}$$
**Outflows:**

$$q_{i}(t)=a_{i}\sqrt{2 g h_{i}(t)}, \quad h_{i}(t)=\frac{m_{i}(t)}{\rho A_{i}}, \quad i \in \left\{ 1,2,3,4 \right\}$$
Where the variables are:
- $A_{i}:$ Cross-sectional area of tank $i$
- $h_{i}:$ Water height of tank $i$
- $a_{i}:$ Cross-sectional area of outlet of tank $i$

## **Converting to a System of ODEs**

$$\dot{x}(t)=f(x(t), u(t), p), \quad x(t_{0})=x_{0}$$
with vectors defined as,
$$x = \begin{bmatrix} m_{1} \\ m_{2} \\ m_{3}\\ m_{4} \end{bmatrix}, \quad u = \begin{bmatrix} F_{1} \\ F_{2} \end{bmatrix}$$
$$p = \left[a_{1} \ a_{2} \ a_{3} \ a_{4} \ A_{1} \ A_{2} \ A_{4} \ \gamma_{1} \ \gamma_{2} \ g \ \rho\right]^{\top}$$

# **The Generic Input-Output Model**

$$\begin{align}
\frac{d x (t)}{dt} &= f(x(t), u(t), p), \quad x(t_{0})=x_{0} \quad \text{(Process Model)} \\
y(t) &= f(x(t), p), \quad \text{(Sensor function)}\\
z(t) &= h(x(t), p), \quad \text{(Output function)}
\end{align}$$
## **Sensor Function**

These are sensors measuring the level/height of all the tanks.
$$y = \begin{bmatrix} y_{1}\\ y_{2} \\ y_{3}\\ y_{4} \end{bmatrix} = \begin{bmatrix} h_{1}\\ h_{2}\\ h_{3}\\ h_{4} \end{bmatrix} = \begin{bmatrix} \frac{m_{1}}{\rho A_{1}}\\ \frac{m_{2}}{\rho A_{2}}\\ \frac{m_{3}}{\rho A_{3}}\\ \frac{m_{4}}{\rho A_{4}}\\ \end{bmatrix} = g \left( x, p \right)$$
## **Output Function**

In this case, we will consider the output as the level in tank $1$ and tank $2$. 
$$z = \begin{bmatrix} z_{1}\\ z_{2} \end{bmatrix} = \begin{bmatrix} h_{1}\\ h_{2} \end{bmatrix} = \begin{bmatrix} \frac{m_{1}}{\rho A_{1}}\\ \frac{m_{2}}{\rho A_{2}} \end{bmatrix} = h(x, p)$$

