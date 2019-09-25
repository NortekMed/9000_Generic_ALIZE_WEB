using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Description résumée de Class1
/// </summary>
public class Class1
{
    Double Pi, SemiMaj, Flat, Esquare;
    Double Epsquare, Aprime, Bprime, Cprime, Dprime;
    Double EEprime, ScaFac0;
    int FalseNN, FalseNS, FalseE;
    Double Rho, Nu, S;
    int Z;
    double X2, Y2;

    public Class1()
    {
    }



    public void Init_Datum()
    {
        Double Invf, a, f, n;

        //Initialize UTM offsets
        FalseNN = 0;
        FalseNS = 10000000;
        FalseE = 500000;
        ScaFac0 = 0.9996;

        //Initialize datum to WGS84 values
        SemiMaj = 6378137;
        //SemiMaj = 6378388;
        //UPGRADE_WARNING: Couldn't resolve default property of object Invf. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        Invf = 298.257223563;
        //Invf = 297;

        a = SemiMaj;
        //UPGRADE_WARNING: Couldn't resolve default property of object Invf. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        f = 1 / Invf;
        Flat = f;
        Esquare = f * (2 - f);
        Epsquare = Esquare / (1 - Esquare);
        n = f / (2 - f);
        Aprime = a * (1 - n + 5 / 4F * (Math.Pow(n, 2) - Math.Pow(n, 3)) + 81 / 64F * (Math.Pow(n, 4) - Math.Pow(n, 5)));
        Bprime = 3 / 2F * a * (n - Math.Pow(n, 2) + 7 / 8F * (Math.Pow(n, 3) - Math.Pow(n, 4)) + 55 / 64F * Math.Pow(n, 5));
        Cprime = 15 / 16F * a * (Math.Pow(n, 2) - Math.Pow(n, 3) + 3 / 4F * (Math.Pow(n, 4) - Math.Pow(n, 5)));
        Dprime = 35 / 48F * a * (Math.Pow(n, 3) - Math.Pow(n, 4) + 11 / 16F * Math.Pow(n, 5));
        EEprime = 315 / 512F * a * (Math.Pow(n, 4) - Math.Pow(n, 5));


        Pi = 4 * System.Math.Atan(1);
    }

    private void rhonus(Double Phi)
    {
        Rho = SemiMaj * (1 - Esquare) / Math.Pow((1 - Esquare * Math.Pow(Math.Sin(Phi), 2)), 1.5);
        Nu = SemiMaj / Math.Pow((1 - Esquare * Math.Pow(Math.Sin(Phi), 2)), 0.5);
        S = Aprime * Phi - Bprime * System.Math.Sin(2 * Phi) + Cprime * System.Math.Sin(4 * Phi) - Dprime * System.Math.Sin(6 * Phi) + EEprime * System.Math.Sin(8 * Phi);
    }

    public double[] XY(Double Lat, Double Lon)
    {
        double[] result = new double[2];
        Double Phi, Lamb, DL, FalseN, sp, cp, tp;
        Double T1, T2, T3, T4, T5, T6, T7, T8, T9;


        Phi = Lat * Pi / 180;
        Lamb = Lon * Pi / 180;
        Z = (int)((Lon + 180) / 6 + 1);
        DL = (Lon - (6 * Z - 183)) * Pi / 180;


        if (Phi >= 0)
        {
            FalseN = FalseNN;
        }
        else
        {
            FalseN = FalseNS;
        }

        sp = System.Math.Sin(Phi);
        cp = System.Math.Cos(Phi);
        tp = System.Math.Tan(Phi);
        rhonus(Phi);

        T1 = S * ScaFac0;
        T2 = Nu * sp * cp * ScaFac0 / 2;
        T3 = Nu * sp * Math.Pow(cp, 3) * ScaFac0 / 24 * (5 - Math.Pow(tp, 2) + 9 * Epsquare * Math.Pow(cp, 2) + 4 * Math.Pow(Epsquare, 2) * Math.Pow(cp, 4));
        T4 = Nu * sp * Math.Pow(cp, 5) * ScaFac0 / 720 * (61 - 58 * Math.Pow(tp, 2) + Math.Pow(tp, 4) + 270 * Epsquare * Math.Pow(cp, 2) - 330 * Math.Pow(tp, 2) * Epsquare * Math.Pow(cp, 2) + 445 * Math.Pow(Epsquare, 2) * Math.Pow(cp, 4) + 324 * Math.Pow(Epsquare, 3) * Math.Pow(cp, 6) - 680 * Math.Pow(tp, 2) * Math.Pow(Epsquare, 2) * Math.Pow(cp, 4) + 88 * Math.Pow(Epsquare, 4) * Math.Pow(cp, 8) - 600 * Math.Pow(tp, 2) * Math.Pow(Epsquare, 3) * Math.Pow(cp, 6) - 192 * Math.Pow(tp, 2) * Math.Pow(Epsquare, 4) * Math.Pow(cp, 8));
        T5 = Nu * sp * Math.Pow(cp, 7) * ScaFac0 / 40320 * (1385 - 3111 * Math.Pow(tp, 2) + 543 * Math.Pow(tp, 4) - Math.Pow(tp, 6));
        T6 = Nu * cp * ScaFac0;
        T7 = Nu * Math.Pow(cp, 3) * ScaFac0 / 6 * (1 - Math.Pow(tp, 2) + Epsquare * Math.Pow(cp, 2));
        T8 = Nu * Math.Pow(cp, 5) * ScaFac0 / 120 * (5 - 18 * Math.Pow(tp, 2) + Math.Pow(tp, 4) + 14 * Epsquare * Math.Pow(cp, 2) - 58 * Math.Pow(tp, 2) * Epsquare * Math.Pow(cp, 2) + 13 * Math.Pow(Epsquare, 2) * Math.Pow(cp, 4) + 4 * Math.Pow(Epsquare, 3) * Math.Pow(cp, 6) - 64 * Math.Pow(tp, 2) * Math.Pow(Epsquare, 2) * Math.Pow(cp, 4) - 24 * Math.Pow(tp, 2) * Math.Pow(Epsquare, 3) * Math.Pow(cp, 6));
        T9 = Nu * Math.Pow(cp, 7) * ScaFac0 / 5040 * (61 - 479 * Math.Pow(tp, 2) + 179 * Math.Pow(tp, 4) - Math.Pow(tp, 6));

        Y2 = FalseN + T1 + Math.Pow(DL, 2) * T2 + Math.Pow(DL, 4) * T3 + Math.Pow(DL, 6) * T4 + Math.Pow(DL, 8) * T5;
        X2 = FalseE + DL * T6 + Math.Pow(DL, 3) * T7 + Math.Pow(DL, 5) * T8 + Math.Pow(DL, 7) * T9;
        result[0] = X2;
        result[1] = Y2;
        return result;
    }

}