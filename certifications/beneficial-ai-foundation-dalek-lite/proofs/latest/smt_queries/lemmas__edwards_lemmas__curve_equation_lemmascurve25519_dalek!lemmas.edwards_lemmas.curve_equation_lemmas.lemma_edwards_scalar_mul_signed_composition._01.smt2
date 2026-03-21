(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun R (Real) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %R (Poly) Real)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const REAL Type)
(declare-const CHAR Type)
(declare-const USIZE Type)
(declare-const ISIZE Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun FLOAT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-fun CONST_BOOL (Bool) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-const $slice Dcr)
(declare-const $dyn Dcr)
(declare-fun DST (Dcr) Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun MUTREF (Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun sized (Dcr) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(declare-fun const_bool (Type) Bool)
(declare-fun mut_ref_current% (Poly) Poly)
(declare-fun mut_ref_future% (Poly) Poly)
(declare-fun mut_ref_update_current% (Poly Poly) Poly)
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_current% (mut_ref_update_current% m arg)) arg)
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_current
   :skolemid skolem_prelude_mut_ref_update_current_current
)))
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_future% (mut_ref_update_current% m arg)) (mut_ref_future% m))
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_future
   :skolemid skolem_prelude_mut_ref_update_current_future
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_current% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_current% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_future% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_future% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type) (arg Poly)) (!
   (=>
    (and
     (has_type m (MUTREF d t))
     (has_type arg t)
    )
    (has_type (mut_ref_update_current% m arg) (MUTREF d t))
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_has_type
   :skolemid skolem_prelude_mut_ref_update_has_type
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (sized (DST d))
   )
   :pattern ((sized (DST d)))
   :qid prelude_sized_decorate_struct_inherit
   :skolemid skolem_prelude_sized_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (sized (REF d))
   :pattern ((sized (REF d)))
   :qid prelude_sized_decorate_ref
   :skolemid skolem_prelude_sized_decorate_ref
)))
(assert
 (forall ((d Dcr)) (!
   (sized (MUT_REF d))
   :pattern ((sized (MUT_REF d)))
   :qid prelude_sized_decorate_mut_ref
   :skolemid skolem_prelude_sized_decorate_mut_ref
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (BOX d t d2))
   :pattern ((sized (BOX d t d2)))
   :qid prelude_sized_decorate_box
   :skolemid skolem_prelude_sized_decorate_box
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (RC d t d2))
   :pattern ((sized (RC d t d2)))
   :qid prelude_sized_decorate_rc
   :skolemid skolem_prelude_sized_decorate_rc
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (ARC d t d2))
   :pattern ((sized (ARC d t d2)))
   :qid prelude_sized_decorate_arc
   :skolemid skolem_prelude_sized_decorate_arc
)))
(assert
 (forall ((d Dcr)) (!
   (sized (GHOST d))
   :pattern ((sized (GHOST d)))
   :qid prelude_sized_decorate_ghost
   :skolemid skolem_prelude_sized_decorate_ghost
)))
(assert
 (forall ((d Dcr)) (!
   (sized (TRACKED d))
   :pattern ((sized (TRACKED d)))
   :qid prelude_sized_decorate_tracked
   :skolemid skolem_prelude_sized_decorate_tracked
)))
(assert
 (forall ((d Dcr)) (!
   (sized (NEVER d))
   :pattern ((sized (NEVER d)))
   :qid prelude_sized_decorate_never
   :skolemid skolem_prelude_sized_decorate_never
)))
(assert
 (forall ((d Dcr)) (!
   (sized (CONST_PTR d))
   :pattern ((sized (CONST_PTR d)))
   :qid prelude_sized_decorate_const_ptr
   :skolemid skolem_prelude_sized_decorate_const_ptr
)))
(assert
 (sized $)
)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (= b (const_bool (CONST_BOOL b)))
   :pattern ((CONST_BOOL b))
   :qid prelude_type_id_const_bool
   :skolemid skolem_prelude_type_id_const_bool
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((r Real)) (!
   (has_type (R r) REAL)
   :pattern ((has_type (R r) REAL))
   :qid prelude_has_type_real
   :skolemid skolem_prelude_has_type_real
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Real)) (!
   (= x (%R (R x)))
   :pattern ((R x))
   :qid prelude_unbox_box_real
   :skolemid skolem_prelude_unbox_box_real
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_box_unbox_usize
   :skolemid skolem_prelude_box_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_box_unbox_isize
   :skolemid skolem_prelude_box_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x REAL)
    (= x (R (%R x)))
   )
   :pattern ((has_type x REAL))
   :qid prelude_box_unbox_real
   :skolemid skolem_prelude_box_unbox_real
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((x Int)) (!
   (=>
    (uInv SZ x)
    (has_type (I x) USIZE)
   )
   :pattern ((has_type (I x) USIZE))
   :qid prelude_has_type_usize
   :skolemid skolem_prelude_has_type_usize
)))
(assert
 (forall ((x Int)) (!
   (=>
    (iInv SZ x)
    (has_type (I x) ISIZE)
   )
   :pattern ((has_type (I x) ISIZE))
   :qid prelude_has_type_isize
   :skolemid skolem_prelude_has_type_isize
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (FLOAT bits))
   )
   :pattern ((has_type (I x) (FLOAT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (uInv SZ (%I x))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_unbox_usize
   :skolemid skolem_prelude_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (iInv SZ (%I x))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_unbox_isize
   :skolemid skolem_prelude_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(declare-fun RAdd (Real Real) Real)
(declare-fun RSub (Real Real) Real)
(declare-fun RMul (Real Real) Real)
(declare-fun RDiv (Real Real) Real)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RAdd x y) (+ x y))
   :pattern ((RAdd x y))
   :qid prelude_radd
   :skolemid skolem_prelude_radd
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RSub x y) (- x y))
   :pattern ((RSub x y))
   :qid prelude_rsub
   :skolemid skolem_prelude_rsub
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RMul x y) (* x y))
   :pattern ((RMul x y))
   :qid prelude_rmul
   :skolemid skolem_prelude_rmul
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RDiv x y) (/ x y))
   :pattern ((RDiv x y))
   :qid prelude_rdiv
   :skolemid skolem_prelude_rdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun has_resolved (Dcr Type Poly) Bool)
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun default_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'module lemmas::edwards_lemmas::curve_equation_lemmas'
;; curve25519-dalek/src/lemmas/edwards_lemmas/curve_equation_lemmas.rs:1328:1: 1328:88 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_basics_2. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_nonzero. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_strictly_positive. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_nonnegative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_unary_negation. FuelId)
(declare-const fuel%vstd!arithmetic.power2.pow2. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%vstd!view.impl&%46.view. FuelId)
(declare-const fuel%vstd!view.impl&%48.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_double. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_negate. FuelId)
(declare-const fuel%curve25519_dalek!specs.primality_specs.is_prime. FuelId)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!function.group_function_axioms. FuelId)
(declare-const fuel%vstd!laws_cmp.group_laws_cmp. FuelId)
(declare-const fuel%vstd!laws_eq.bool_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.usize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.isize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.group_laws_eq. FuelId)
(declare-const fuel%vstd!layout.group_layout_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_filter_ensures. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_default. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms. FuelId)
(declare-const fuel%vstd!std_specs.hash.group_hash_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple.
  fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. fuel%vstd!arithmetic.div_mod.lemma_mod_twice.
  fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_mod_bound. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. fuel%vstd!arithmetic.mul.lemma_mul_basics_2.
  fuel%vstd!arithmetic.mul.lemma_mul_nonzero. fuel%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.
  fuel%vstd!arithmetic.mul.lemma_mul_strictly_positive. fuel%vstd!arithmetic.mul.lemma_mul_nonnegative.
  fuel%vstd!arithmetic.mul.lemma_mul_unary_negation. fuel%vstd!arithmetic.power2.pow2.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view.
  fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%26.view.
  fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%44.view. fuel%vstd!view.impl&%46.view.
  fuel%vstd!view.impl&%48.view. fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.
  fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
  fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine. fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.
  fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards. fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards. fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.
  fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards. fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.
  fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels. fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels.
  fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels. fuel%curve25519_dalek!specs.edwards_specs.edwards_add.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_double. fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point. fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed. fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.mask51.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.
  fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec. fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.
  fuel%curve25519_dalek!specs.field_specs_u64.spec_negate. fuel%curve25519_dalek!specs.primality_specs.is_prime.
  fuel%vstd!array.group_array_axioms. fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp.
  fuel%vstd!laws_eq.bool_laws.group_laws_eq. fuel%vstd!laws_eq.u8_laws.group_laws_eq.
  fuel%vstd!laws_eq.i8_laws.group_laws_eq. fuel%vstd!laws_eq.u16_laws.group_laws_eq.
  fuel%vstd!laws_eq.i16_laws.group_laws_eq. fuel%vstd!laws_eq.u32_laws.group_laws_eq.
  fuel%vstd!laws_eq.i32_laws.group_laws_eq. fuel%vstd!laws_eq.u64_laws.group_laws_eq.
  fuel%vstd!laws_eq.i64_laws.group_laws_eq. fuel%vstd!laws_eq.u128_laws.group_laws_eq.
  fuel%vstd!laws_eq.i128_laws.group_laws_eq. fuel%vstd!laws_eq.usize_laws.group_laws_eq.
  fuel%vstd!laws_eq.isize_laws.group_laws_eq. fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms.
  fuel%vstd!map.group_map_axioms. fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_filter_ensures. fuel%vstd!seq_lib.group_seq_lib_default.
  fuel%vstd!set.group_set_axioms. fuel%vstd!set_lib.group_set_lib_default. fuel%vstd!slice.group_slice_axioms.
  fuel%vstd!string.group_string_axioms. fuel%vstd!std_specs.bits.group_bits_axioms.
  fuel%vstd!std_specs.control_flow.group_control_flow_axioms. fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.
  fuel%vstd!std_specs.hash.group_hash_axioms. fuel%vstd!std_specs.range.group_range_axioms.
  fuel%vstd!std_specs.slice.group_slice_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!array.group_array_axioms.)
  (and
   (fuel_bool_default fuel%vstd!array.array_len_matches_n.)
   (fuel_bool_default fuel%vstd!array.lemma_array_index.)
   (fuel_bool_default fuel%vstd!array.axiom_array_ext_equal.)
   (fuel_bool_default fuel%vstd!array.axiom_array_has_resolved.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
  (and
   (fuel_bool_default fuel%vstd!laws_eq.bool_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.usize_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.isize_laws.group_laws_eq.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
  (and
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq.)
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
  (and
   (fuel_bool_default fuel%vstd!slice.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_ext_equal.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_has_resolved.)
)))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_default.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!function.group_function_axioms.)
   (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_cmp.group_laws_cmp.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
   (fuel_bool_default fuel%vstd!layout.group_layout_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.hash.group_hash_axioms.)
)))

;; Trait-Decls
(declare-fun tr_bound%vstd!array.ArrayAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)

;; Datatypes
(declare-fun pointee_metadata% (Dcr) Type)
(declare-fun pointee_metadata%% (Dcr) Dcr)
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata% d) TYPE%tuple%0.)
   )
   :pattern ((pointee_metadata% d))
   :qid prelude_project_pointee_metadata_sized
   :skolemid skolem_prelude_project_pointee_metadata_sized
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata%% d) $)
   )
   :pattern ((pointee_metadata%% d))
   :qid prelude_project_pointee_metadata_decoration_sized
   :skolemid skolem_prelude_project_pointee_metadata_decoration_sized
)))
(assert
 (= (pointee_metadata% $slice) USIZE)
)
(assert
 (= (pointee_metadata%% $slice) $)
)
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata% (DST d)) (pointee_metadata% d))
   :pattern ((pointee_metadata% (DST d)))
   :qid prelude_project_pointee_metadata_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata%% (DST d)) (pointee_metadata%% d))
   :pattern ((pointee_metadata%% (DST d)))
   :qid prelude_project_pointee_metadata_decoration_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decoration_decorate_struct_inherit
)))
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   0
  ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. 0) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   0
  ) (curve25519_dalek!edwards.EdwardsPoint. 0) (tuple%0. 0) (tuple%2. 0) (tuple%3. 0)
  (tuple%4. 0)
 ) (((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
    (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     Int
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint (
     curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Y
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
    (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_plus_x
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_minus_x
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?xy2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
    (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
  ) ((tuple%0./tuple%0)) ((tuple%2./tuple%2 (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1
     Poly
   ))
  ) ((tuple%3./tuple%3 (tuple%3./tuple%3/?0 Poly) (tuple%3./tuple%3/?1 Poly) (tuple%3./tuple%3/?2
     Poly
   ))
  ) ((tuple%4./tuple%4 (tuple%4./tuple%4/?0 Poly) (tuple%4./tuple%4/?1 Poly) (tuple%4./tuple%4/?2
     Poly
    ) (tuple%4./tuple%4/?3 Poly)
))))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun tuple%3./tuple%3/0 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/1 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/2 (tuple%3.) Poly)
(declare-fun tuple%4./tuple%4/0 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/1 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/2 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/3 (tuple%4.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!edwards.EdwardsPoint. Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%3. (Dcr Type Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%4. (Dcr Type Dcr Type Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Poly
)
(declare-fun %Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (
  Poly
 ) curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (
  curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 ) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)
(declare-fun Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly) curve25519_dalek!edwards.EdwardsPoint.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(declare-fun Poly%tuple%3. (tuple%3.) Poly)
(declare-fun %Poly%tuple%3. (Poly) tuple%3.)
(declare-fun Poly%tuple%4. (tuple%4.) Poly)
(declare-fun %Poly%tuple%4. (Poly) tuple%4.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%array%. (Poly%array%. x)))
   :pattern ((Poly%array%. x))
   :qid internal_crate__array___box_axiom_definition
   :skolemid skolem_internal_crate__array___box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (x Poly)) (!
   (=>
    (has_type x (ARRAY T&. T& N&. N&))
    (= x (Poly%array%. (%Poly%array%. x)))
   )
   :pattern ((has_type x (ARRAY T&. T& N&. N&)))
   :qid internal_crate__array___unbox_axiom_definition
   :skolemid skolem_internal_crate__array___unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (= x (%Poly%vstd!raw_ptr.Provenance. (Poly%vstd!raw_ptr.Provenance. x)))
   :pattern ((Poly%vstd!raw_ptr.Provenance. x))
   :qid internal_vstd__raw_ptr__Provenance_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%vstd!raw_ptr.Provenance.)
    (= x (Poly%vstd!raw_ptr.Provenance. (%Poly%vstd!raw_ptr.Provenance. x)))
   )
   :pattern ((has_type x TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.)
   :pattern ((has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_has_type_always_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_has_type_always_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (= x (%Poly%allocator_global%. (Poly%allocator_global%. x)))
   :pattern ((Poly%allocator_global%. x))
   :qid internal_crate__allocator_global___box_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ALLOCATOR_GLOBAL)
    (= x (Poly%allocator_global%. (%Poly%allocator_global%. x)))
   )
   :pattern ((has_type x ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___unbox_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___unbox_axiom_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL)
   :pattern ((has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___has_type_always_definition
   :skolemid skolem_internal_crate__allocator_global___has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= x (%Poly%vstd!raw_ptr.PtrData. (Poly%vstd!raw_ptr.PtrData. x)))
   :pattern ((Poly%vstd!raw_ptr.PtrData. x))
   :qid internal_vstd__raw_ptr__PtrData_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (= x (Poly%vstd!raw_ptr.PtrData. (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&)))
   :qid internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_addr! Int) (_provenance! vstd!raw_ptr.Provenance.) (
    _metadata! Poly
   )
  ) (!
   (=>
    (and
     (uInv SZ _addr!)
     (has_type _metadata! (pointee_metadata% T&.))
    )
    (has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr! _provenance!
       _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr!
       _provenance! _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/addr x) (vstd!raw_ptr.PtrData./PtrData/?addr x))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (uInv SZ (vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)) (has_type
     x (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/provenance x) (vstd!raw_ptr.PtrData./PtrData/?provenance
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/provenance x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/metadata x) (vstd!raw_ptr.PtrData./PtrData/?metadata
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
     (pointee_metadata% T&.)
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   )
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (= x (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
)))
(assert
 (forall ((_limbs! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 _limbs!)
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
    ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= x (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   ))
   :pattern ((Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     x
   ))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (= x (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
)))
(assert
 (forall ((_gcd! Int) (_x! Int) (_y! Int)) (!
   (=>
    (<= 0 _gcd!)
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
    ) (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
   )
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint
       _X! _Y! _Z!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint _X!
       _Y! _Z!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Y
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_y_plus_x! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_y_minus_x!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_xy2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _y_plus_x!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _y_minus_x!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _xy2d!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ))
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
       _y_plus_x! _y_minus_x! _xy2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint _y_plus_x!
       _y_minus_x! _xy2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_plus_x
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_minus_x
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?xy2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     x
   ))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_Y_plus_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y_minus_X!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_plus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_minus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T2d!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= x (%Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!edwards.EdwardsPoint. x))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (= x (Poly%curve25519_dalek!edwards.EdwardsPoint. (%Poly%curve25519_dalek!edwards.EdwardsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= x (%Poly%tuple%3. (Poly%tuple%3. x)))
   :pattern ((Poly%tuple%3. x))
   :qid internal_crate__tuple__3_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (= x (Poly%tuple%3. (%Poly%tuple%3. x)))
   )
   :pattern ((has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&)))
   :qid internal_crate__tuple__3_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (_0!
    Poly
   ) (_1! Poly) (_2! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
    )
    (has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :pattern ((has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&.
      T%0& T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3_constructor_definition
   :skolemid skolem_internal_tuple__3./tuple__3_constructor_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/0 x) (tuple%3./tuple%3/?0 x))
   :pattern ((tuple%3./tuple%3/0 x))
   :qid internal_tuple__3./tuple__3/0_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) T%0&)
   )
   :pattern ((tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/0_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/1 x) (tuple%3./tuple%3/?1 x))
   :pattern ((tuple%3./tuple%3/1 x))
   :qid internal_tuple__3./tuple__3/1_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) T%1&)
   )
   :pattern ((tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/1_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/2 x) (tuple%3./tuple%3/?2 x))
   :pattern ((tuple%3./tuple%3/2 x))
   :qid internal_tuple__3./tuple__3/2_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) T%2&)
   )
   :pattern ((tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/2_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/0 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/0 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/0
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/0
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/1 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/1 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/1
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/1
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/2 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/2 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/2
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/2
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (deep
    Bool
   ) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type y (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (ext_eq deep T%0& (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (tuple%3./tuple%3/0 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%1& (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (tuple%3./tuple%3/1 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%2& (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (tuple%3./tuple%3/2 (%Poly%tuple%3.
        y
    ))))
    (ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y))
   :qid internal_tuple__3./tuple__3_ext_equal_definition
   :skolemid skolem_internal_tuple__3./tuple__3_ext_equal_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= x (%Poly%tuple%4. (Poly%tuple%4. x)))
   :pattern ((Poly%tuple%4. x))
   :qid internal_crate__tuple__4_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (= x (Poly%tuple%4. (%Poly%tuple%4. x)))
   )
   :pattern ((has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)))
   :qid internal_crate__tuple__4_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (_0! Poly) (_1! Poly) (_2! Poly) (_3! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
     (has_type _3! T%3&)
    )
    (has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :pattern ((has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4.
      T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4_constructor_definition
   :skolemid skolem_internal_tuple__4./tuple__4_constructor_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/0 x) (tuple%4./tuple%4/?0 x))
   :pattern ((tuple%4./tuple%4/0 x))
   :qid internal_tuple__4./tuple__4/0_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) T%0&)
   )
   :pattern ((tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/0_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/1 x) (tuple%4./tuple%4/?1 x))
   :pattern ((tuple%4./tuple%4/1 x))
   :qid internal_tuple__4./tuple__4/1_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) T%1&)
   )
   :pattern ((tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/1_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/2 x) (tuple%4./tuple%4/?2 x))
   :pattern ((tuple%4./tuple%4/2 x))
   :qid internal_tuple__4./tuple__4/2_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) T%2&)
   )
   :pattern ((tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/2_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/3 x) (tuple%4./tuple%4/?3 x))
   :pattern ((tuple%4./tuple%4/3 x))
   :qid internal_tuple__4./tuple__4/3_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) T%3&)
   )
   :pattern ((tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/3_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/0 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/0 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/0
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/0
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/1 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/1 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/1
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/1
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/2 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/2 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/2
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/2
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/3 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/3 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/3
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/3
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (deep Bool) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (has_type y (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (ext_eq deep T%0& (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (tuple%4./tuple%4/0 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%1& (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (tuple%4./tuple%4/1 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%2& (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (tuple%4./tuple%4/2 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%3& (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (tuple%4./tuple%4/3 (%Poly%tuple%4.
        y
    ))))
    (ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)
     x y
   ))
   :qid internal_tuple__4./tuple__4_ext_equal_definition
   :skolemid skolem_internal_tuple__4./tuple__4_ext_equal_definition
)))
(declare-fun array_new (Dcr Type Int %%Function%%) Poly)
(declare-fun array_index (Dcr Type Dcr Type %%Function%% Poly) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (= (array_new Tdcr T N Fn) (Poly%array%. Fn))
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_array_new
   :skolemid skolem_prelude_array_new
)))
(declare-fun %%apply%%1 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%1 Fn i) T)
      )
      :pattern ((has_type (%%apply%%1 Fn i) T))
      :qid prelude_has_type_array_elts
      :skolemid skolem_prelude_has_type_array_elts
    ))
    (has_type (array_new Tdcr T N Fn) (ARRAY Tdcr T $ (CONST_INT N)))
   )
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_has_type_array_new
   :skolemid skolem_prelude_has_type_array_new
)))
(assert
 (forall ((Tdcr Dcr) (T Type) (Ndcr Dcr) (N Type) (Fn %%Function%%) (i Poly)) (!
   (=>
    (and
     (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr N))
     (has_type i INT)
    )
    (has_type (array_index Tdcr T $ N Fn i) T)
   )
   :pattern ((array_index Tdcr T $ N Fn i) (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr
      N
   )))
   :qid prelude_has_type_array_index
   :skolemid skolem_prelude_has_type_array_index
)))
(assert
 (!
  (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%) (i Int)) (!
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%1 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%1 Fn i))
    :qid prelude_array_index_trigger
    :skolemid skolem_prelude_array_index_trigger
  ))
  :named
  prelude_axiom_array_index
))

;; Trait-Bounds
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!view.View. Self%&. Self%&)
    (sized (proj%%vstd!view.View./V Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!view.View. Self%&. Self%&))
   :qid internal_vstd__view__View_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__view__View_trait_type_bounds_definition
)))

;; Associated-Type-Impls
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) $)
   :pattern ((proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $slice (SLICE T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $slice (SLICE T&. T&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (REF A&.) A&) (proj%%vstd!view.View./V A&. A&))
   :pattern ((proj%%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (REF A&.) A&) (proj%vstd!view.View./V A&. A&))
   :pattern ((proj%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $ TYPE%tuple%0.) $)
)
(assert
 (= (proj%vstd!view.View./V $ TYPE%tuple%0.) TYPE%tuple%0.)
)
(assert
 (= (proj%%vstd!view.View./V $ BOOL) $)
)
(assert
 (= (proj%vstd!view.View./V $ BOOL) BOOL)
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (DST (proj%%vstd!view.View./V
      A1&. A1&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (TYPE%tuple%2.
     (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&) (proj%%vstd!view.View./V
      A1&. A1&
     ) (proj%vstd!view.View./V A1&. A1&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (DST (proj%%vstd!view.View./V A2&. A2&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (TYPE%tuple%3. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (DST (proj%%vstd!view.View./V A3&. A3&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (TYPE%tuple%4. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&) (proj%%vstd!view.View./V A3&. A3&) (proj%vstd!view.View./V
      A3&. A3&
   )))
   :pattern ((proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
      A3&. A3&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::slice::spec_slice_len
(declare-fun vstd!slice.spec_slice_len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::view::View::view
(declare-fun vstd!view.View.view.? (Dcr Type Poly) Poly)
(declare-fun vstd!view.View.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::array_view
(declare-fun vstd!array.array_view.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.field_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_x
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_x.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_y
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_y.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_z
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_z.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_t
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_t.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly) tuple%4.)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?
 (Poly Poly) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
 (Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
 (Poly Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
 (Poly Poly Fuel) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
 (Poly Poly) Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::field_inv
(declare-fun curve25519_dalek!specs.field_specs.field_inv.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_mul
(declare-fun curve25519_dalek!specs.field_specs.field_mul.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::field_neg
(declare-fun curve25519_dalek!specs.field_specs.field_neg.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_reduce
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(declare-fun curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? () %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(declare-fun curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_negate
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::edwards_specs::negate_affine_niels
(declare-fun curve25519_dalek!specs.edwards_specs.negate_affine_niels.? (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::negate_projective_niels
(declare-fun curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (Poly)
 curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(declare-fun curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::field_square
(declare-fun curve25519_dalek!specs.field_specs.field_square.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?
 (Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_identity
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_identity.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_add
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_add.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_double
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_double.? (Poly Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly Poly)
 tuple%2.
)
(declare-fun curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? (Poly Poly
  Fuel
 ) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::negate_lemmas::all_neg_limbs_positive
(declare-fun curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul_signed
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly
  Poly
 ) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::affine_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_affine_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::affine_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_point_edwards_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?
 (Poly) tuple%3.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_projective_point_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
 (Poly) curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_affine_niels
(declare-fun curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_projective_niels
(declare-fun curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (Poly)
 curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_neg
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_projective_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::primality_specs::is_prime
(declare-fun curve25519_dalek!specs.primality_specs.is_prime.? (Poly) Bool)

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%0
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%1
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_0
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_0
))))

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        )
       ) (%I len!)
    )))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_1
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_1
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (%I len!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_2
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
          ))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_3
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_3
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_4
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_4
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
              i$
          ))))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_5
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_5
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_6
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_6
))))

;; Function-Axioms vstd::slice::spec_slice_len
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
   (=>
    (has_type slice! (SLICE T&. T&))
    (uInv SZ (vstd!slice.spec_slice_len.? T&. T& slice!))
   )
   :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
   :qid internal_vstd!slice.spec_slice_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.spec_slice_len.?_pre_post_definition
)))

;; Function-Axioms vstd::view::View::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!view.View.view.? Self%&. Self%& self!) (proj%vstd!view.View./V Self%&.
      Self%&
   )))
   :pattern ((vstd!view.View.view.? Self%&. Self%& self!))
   :qid internal_vstd!view.View.view.?_pre_post_definition
   :skolemid skolem_internal_vstd!view.View.view.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $slice (SLICE T&. T&)))
   :qid internal_vstd__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
    (=>
     (has_type slice! (SLICE T&. T&))
     (=>
      (sized T&.)
      (= (vstd!slice.spec_slice_len.? T&. T& slice!) (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.?
         $slice (SLICE T&. T&) slice!
    )))))
    :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
    :qid user_vstd__slice__axiom_spec_len_7
    :skolemid skolem_user_vstd__slice__axiom_spec_len_7
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::slice::SliceAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::slice::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!slice.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!slice.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)
       i!
    )))
    :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&.
      T& self! i!
    ))
    :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&)
   )
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&))
   :qid internal_vstd__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_slice_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (SLICE T&. T&))
      (has_type a2! (SLICE T&. T&))
     )
     (=>
      (sized T&.)
      (= (ext_eq false (SLICE T&. T&) a1! a2!) (and
        (= (vstd!slice.spec_slice_len.? T&. T& a1!) (vstd!slice.spec_slice_len.? T&. T& a2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& a1!))
            ))
            (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a1!) i$)
             (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a2!) i$)
          )))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a1!
            ) i$
          ))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a2!
            ) i$
          ))
          :qid user_vstd__slice__axiom_slice_ext_equal_8
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_8
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_9
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_9
))))

;; Broadcast vstd::slice::axiom_slice_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type slice! (SLICE T&. T&))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& slice!))
       ))
       (=>
        (has_resolved $slice (SLICE T&. T&) slice!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE
            T&. T&
           ) slice!
          ) i!
    ))))))
    :pattern ((has_resolved $slice (SLICE T&. T&) slice!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) i!
    ))
    :qid user_vstd__slice__axiom_slice_has_resolved_10
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_10
))))

;; Function-Axioms vstd::array::array_view
(assert
 (fuel_bool_default fuel%vstd!array.array_view.)
)
(declare-fun %%lambda%%0 (Dcr Type Dcr Type %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Dcr) (%%hole%%3 Type) (%%hole%%4
    %%Function%%
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (array_index %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 i$)
   )
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
    (= (vstd!array.array_view.? T&. T& N&. N& a!) (vstd!seq.Seq.new.? T&. T& $ (TYPE%fun%1.
       $ INT T&. T&
      ) (I (const_int N&)) (Poly%fun%1. (mk_fun (%%lambda%%0 T&. T& N&. N& (%Poly%array%. a!))))
    ))
    :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
    :qid internal_vstd!array.array_view.?_definition
    :skolemid skolem_internal_vstd!array.array_view.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
   (=>
    (has_type a! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.array_view.? T&. T& N&. N& a!) (TYPE%vstd!seq.Seq. T&. T&))
   )
   :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
   :qid internal_vstd!array.array_view.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.array_view.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!array.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%0.view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) (vstd!array.array_view.? T&.
       T& N&. N& self!
    )))
    :pattern ((vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__array__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::array::array_len_matches_n
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_len_matches_n.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!))
       (const_int N&)
    )))
    :pattern ((vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
       ar!
    )))
    :qid user_vstd__array__array_len_matches_n_11
    :skolemid skolem_user_vstd__array__array_len_matches_n_11
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::array::ArrayAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!array.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (i! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!)
       i!
    )))
    :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&.
      T& self! i!
    ))
    :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&. T&)
   )
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&.
     T&
   ))
   :qid internal_vstd__array__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::array::lemma_array_index
(assert
 (=>
  (fuel_bool fuel%vstd!array.lemma_array_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type a! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized T&.)
        (uInv SZ (const_int N&))
       )
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
      )))
      (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!)
        i!
       ) (vstd!seq.Seq.index.? T&. T& (vstd!array.array_view.? T&. T& N&. N& a!) i!)
    )))
    :pattern ((array_index T&. T& N&. N& (%Poly%array%. a!) i!))
    :qid user_vstd__array__lemma_array_index_12
    :skolemid skolem_user_vstd__array__lemma_array_index_12
))))

;; Broadcast vstd::array::axiom_array_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (ARRAY T&. T& N&. N&))
      (has_type a2! (ARRAY T&. T& N&. N&))
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (ext_eq false (ARRAY T&. T& N&. N&) a1! a2!) (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a1!)
             i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a2!)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a1!
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a2!
           ) i$
         ))
         :qid user_vstd__array__axiom_array_ext_equal_13
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_13
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_14
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_14
))))

;; Broadcast vstd::array::axiom_array_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (array! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type array! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
       ))
       (=>
        (has_resolved $ (ARRAY T&. T& N&. N&) array!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&.
            T& N&. N&
           ) array!
          ) i!
    ))))))
    :pattern ((has_resolved $ (ARRAY T&. T& N&. N&) array!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) array!) i!
    ))
    :qid user_vstd__array__axiom_array_has_resolved_15
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_15
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq
(assert
 (forall ((T&. Dcr) (T& Type) (data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!) (PTR T&. T&))
   )
   :pattern ((vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. $ (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. $ (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (= (vstd!raw_ptr.view_reverse_for_eq.? T&. T& (vstd!view.View.view.? $ (PTR T&. T&)
        a!
       )
      ) a!
    ))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_16
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_16
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq_sized
(assert
 (forall ((T&. Dcr) (T& Type) (addr! Poly) (provenance! Poly)) (!
   (=>
    (and
     (has_type addr! USIZE)
     (has_type provenance! TYPE%vstd!raw_ptr.Provenance.)
    )
    (has_type (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!) (PTR
      T&. T&
   )))
   :pattern ((vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq_sized
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (=>
      (sized T&.)
      (= (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& (I (vstd!raw_ptr.PtrData./PtrData/addr
          (%Poly%vstd!raw_ptr.PtrData. (vstd!view.View.view.? $ (PTR T&. T&) a!))
         )
        ) (Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.PtrData./PtrData/provenance (%Poly%vstd!raw_ptr.PtrData.
           (vstd!view.View.view.? $ (PTR T&. T&) a!)
        )))
       ) a!
    )))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_17
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_17
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%4 Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%4
      (< x! m!)
     )
     (=>
      %%global_location_label%%5
      (< 0 m!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (= (EucMod x! m!) x!))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%6
     (not (= d! 0))
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (= x! (Add (Mul d!
       (EucDiv x! d!)
      ) (EucMod x! d!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.)
  (forall ((x! Int) (d! Int)) (!
    (=>
     (not (= d! 0))
     (= x! (Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    )
    :pattern ((Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_18
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_18
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_by_multiple
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_by_multiple. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((b! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!) (and
     (=>
      %%global_location_label%%7
      (<= 0 b!)
     )
     (=>
      %%global_location_label%%8
      (< 0 d!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_by_multiple. (Int Int) Bool)
(assert
 (forall ((b! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!) (= (EucDiv (Mul b! d!)
      d!
     ) b!
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_by_multiple
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple.)
  (forall ((b! Int) (d! Int)) (!
    (=>
     (and
      (<= 0 b!)
      (< 0 d!)
     )
     (= (EucDiv (Mul b! d!) d!) b!)
    )
    :pattern ((EucDiv (Mul b! d!) d!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_by_multiple_19
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_by_multiple_19
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_self_0
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (=>
     %%global_location_label%%9
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(assert
 (forall ((m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (= (EucMod m! m!) 0))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_self_0. m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_self_0
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_self_0.)
  (forall ((m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod m! m!) 0)
    )
    :pattern ((EucMod m! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_self_0_20
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_self_0_20
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_twice
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (=>
     %%global_location_label%%10
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_twice._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_twice._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (= (EucMod (EucMod x! m!) m!)
     (EucMod x! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_twice._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_twice._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_twice
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_twice.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod (EucMod x! m!) m!) (EucMod x! m!))
    )
    :pattern ((EucMod (EucMod x! m!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_21
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_21
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (=>
     %%global_location_label%%11
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (= (EucMod (Add
       (Mul m! a!) b!
      ) m!
     ) (EucMod b! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish.)
  (forall ((a! Int) (b! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (Mul m! a!) b!) m!) (EucMod b! m!))
    )
    :pattern ((EucMod (Add (Mul m! a!) b!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_22
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_22
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_add_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (=>
     %%global_location_label%%12
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (= (EucMod (Add (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Add x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_add_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Add x! y!) m!))
    )
    :pattern ((EucMod (Add x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_add_mod_noop_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_add_mod_noop_23
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%13
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_bound._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_bound._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (let
     ((tmp%%$ (EucMod x! m!)))
     (and
      (<= 0 tmp%%$)
      (< tmp%%$ m!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_bound._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_bound._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_bound
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_bound.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (let
      ((tmp%%$ (EucMod x! m!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ m!)
    )))
    :pattern ((EucMod x! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_24
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_24
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (=>
     %%global_location_label%%14
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (= (EucMod (Mul (EucMod
        x! m!
       ) y!
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_25
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_25
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%15
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (= (EucMod (Mul x!
       (EucMod y! m!)
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_26
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_26
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics. x!) (and
     (= (Mul 0 x!) 0)
     (= (Mul x! 0) 0)
     (= (Mul x! 1) x!)
     (= (Mul 1 x!) x!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
)))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics_2
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics_2. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics_2. x!) (= (Mul x! 0) 0))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics_2. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics_2._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics_2._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_basics_2
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_basics_2.)
  (forall ((x! Int)) (!
    (= (Mul x! 0) 0)
    :pattern ((Mul x! 0))
    :qid user_vstd__arithmetic__mul__lemma_mul_basics_2_27
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_basics_2_27
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_nonzero
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_nonzero. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_nonzero. x! y!) (= (not (= (Mul x! y!) 0)) (and
      (not (= x! 0))
      (not (= y! 0))
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_nonzero. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_nonzero._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_nonzero._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_nonzero
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_nonzero.)
  (forall ((x! Int) (y! Int)) (!
    (= (not (= (Mul x! y!) 0)) (and
      (not (= x! 0))
      (not (= y! 0))
    ))
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_nonzero_28
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_nonzero_28
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_by_zero_is_zero
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero. x!) (and
     (= (Mul x! 0) 0)
     (= (Mul 0 x!) 0)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_by_zero_is_zero._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_by_zero_is_zero._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_by_zero_is_zero
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero.)
  (forall ((x! Int)) (!
    (and
     (= (Mul x! 0) 0)
     (= (Mul 0 x!) 0)
    )
    :pattern ((Mul x! 0))
    :pattern ((Mul 0 x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_by_zero_is_zero_29
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_by_zero_is_zero_29
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_associative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_associative. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!) (= (Mul x! (Mul y! z!))
     (Mul (Mul x! y!) z!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_associative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_associative.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Mul y! z!)) (Mul (Mul x! y!) z!))
    :pattern ((Mul x! (Mul y! z!)))
    :pattern ((Mul (Mul x! y!) z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_30
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_30
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_commutative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_commutative. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!) (= (Mul x! y!) (Mul y!
      x!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_commutative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.)
  (forall ((x! Int) (y! Int)) (!
    (= (Mul x! y!) (Mul y! x!))
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_31
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_31
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_add
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. x! y! z!) (= (Mul x! (Add
       y! z!
      )
     ) (Add (Mul x! y!) (Mul x! z!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_add
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Add y! z!)) (Add (Mul x! y!) (Mul x! z!)))
    :pattern ((Mul x! (Add y! z!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_32
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_32
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_sub_other_way
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. x! y! z!) (= (
      Mul (Sub y! z!) x!
     ) (Sub (Mul y! x!) (Mul z! x!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_sub_other_way
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul (Sub y! z!) x!) (Sub (Mul y! x!) (Mul z! x!)))
    :pattern ((Mul (Sub y! z!) x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_33
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_33
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_strictly_positive
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. x! y!) (=>
     (and
      (< 0 x!)
      (< 0 y!)
     )
     (< 0 (Mul x! y!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_strictly_positive._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_strictly_positive._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_strictly_positive
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_strictly_positive.)
  (forall ((x! Int) (y! Int)) (!
    (=>
     (and
      (< 0 x!)
      (< 0 y!)
     )
     (< 0 (Mul x! y!))
    )
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_strictly_positive_34
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_strictly_positive_34
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_nonnegative
(declare-fun req%vstd!arithmetic.mul.lemma_mul_nonnegative. (Int Int) Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!) (and
     (=>
      %%global_location_label%%16
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%17
      (<= 0 y!)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_nonnegative. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!) (<= 0 (Mul x! y!)))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_nonnegative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_nonnegative.)
  (forall ((x! Int) (y! Int)) (!
    (=>
     (and
      (<= 0 x!)
      (<= 0 y!)
     )
     (<= 0 (Mul x! y!))
    )
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_nonnegative_35
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_nonnegative_35
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_unary_negation
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_unary_negation. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_unary_negation. x! y!) (let
     ((tmp%%$ (Sub 0 (Mul x! y!))))
     (and
      (= (Mul (Sub 0 x!) y!) tmp%%$)
      (= tmp%%$ (Mul x! (Sub 0 y!)))
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_unary_negation. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_unary_negation._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_unary_negation._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_unary_negation
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_unary_negation.)
  (forall ((x! Int) (y! Int)) (!
    (let
     ((tmp%%$ (Sub 0 (Mul x! y!))))
     (and
      (= (Mul (Sub 0 x!) y!) tmp%%$)
      (= tmp%%$ (Mul x! (Sub 0 y!)))
    ))
    :pattern ((Mul (Sub 0 x!) y!))
    :pattern ((Mul x! (Sub 0 y!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_unary_negation_36
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_unary_negation_36
))))

;; Function-Axioms vstd::arithmetic::power2::pow2
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.pow2.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (= (vstd!arithmetic.power2.pow2.? e!) (nClip (vstd!arithmetic.power.pow.? (I 2) e!)))
    )
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid internal_vstd!arithmetic.power2.pow2.?_definition
    :skolemid skolem_internal_vstd!arithmetic.power2.pow2.?_definition
))))
(assert
 (forall ((e! Poly)) (!
   (=>
    (has_type e! NAT)
    (<= 0 (vstd!arithmetic.power2.pow2.? e!))
   )
   :pattern ((vstd!arithmetic.power2.pow2.? e!))
   :qid internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
   :skolemid skolem_internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
)))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_pos
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_pos. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_pos. e!) (> (vstd!arithmetic.power2.pow2.?
      (I e!)
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_pos. e!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_pos
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_pos.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (> (vstd!arithmetic.power2.pow2.? e!) 0)
    )
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_37
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_37
))))

;; Function-Specs vstd::arithmetic::power2::lemma2_to64
(declare-fun ens%vstd!arithmetic.power2.lemma2_to64. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma2_to64. no%param) (and
     (= (vstd!arithmetic.power2.pow2.? (I 0)) 1)
     (= (vstd!arithmetic.power2.pow2.? (I 1)) 2)
     (= (vstd!arithmetic.power2.pow2.? (I 2)) 4)
     (= (vstd!arithmetic.power2.pow2.? (I 3)) 8)
     (= (vstd!arithmetic.power2.pow2.? (I 4)) 16)
     (= (vstd!arithmetic.power2.pow2.? (I 5)) 32)
     (= (vstd!arithmetic.power2.pow2.? (I 6)) 64)
     (= (vstd!arithmetic.power2.pow2.? (I 7)) 128)
     (= (vstd!arithmetic.power2.pow2.? (I 8)) 256)
     (= (vstd!arithmetic.power2.pow2.? (I 9)) 512)
     (= (vstd!arithmetic.power2.pow2.? (I 10)) 1024)
     (= (vstd!arithmetic.power2.pow2.? (I 11)) 2048)
     (= (vstd!arithmetic.power2.pow2.? (I 12)) 4096)
     (= (vstd!arithmetic.power2.pow2.? (I 13)) 8192)
     (= (vstd!arithmetic.power2.pow2.? (I 14)) 16384)
     (= (vstd!arithmetic.power2.pow2.? (I 15)) 32768)
     (= (vstd!arithmetic.power2.pow2.? (I 16)) 65536)
     (= (vstd!arithmetic.power2.pow2.? (I 17)) 131072)
     (= (vstd!arithmetic.power2.pow2.? (I 18)) 262144)
     (= (vstd!arithmetic.power2.pow2.? (I 19)) 524288)
     (= (vstd!arithmetic.power2.pow2.? (I 20)) 1048576)
     (= (vstd!arithmetic.power2.pow2.? (I 21)) 2097152)
     (= (vstd!arithmetic.power2.pow2.? (I 22)) 4194304)
     (= (vstd!arithmetic.power2.pow2.? (I 23)) 8388608)
     (= (vstd!arithmetic.power2.pow2.? (I 24)) 16777216)
     (= (vstd!arithmetic.power2.pow2.? (I 25)) 33554432)
     (= (vstd!arithmetic.power2.pow2.? (I 26)) 67108864)
     (= (vstd!arithmetic.power2.pow2.? (I 27)) 134217728)
     (= (vstd!arithmetic.power2.pow2.? (I 28)) 268435456)
     (= (vstd!arithmetic.power2.pow2.? (I 29)) 536870912)
     (= (vstd!arithmetic.power2.pow2.? (I 30)) 1073741824)
     (= (vstd!arithmetic.power2.pow2.? (I 31)) 2147483648)
     (= (vstd!arithmetic.power2.pow2.? (I 32)) 4294967296)
     (= (vstd!arithmetic.power2.pow2.? (I 64)) 18446744073709551616)
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma2_to64. no%param))
   :qid internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%3::view
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%3.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%3.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!) (vstd!view.View.view.?
      $ (PTR T&. T&) self!
    ))
    :pattern ((vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__3_trait_impl_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::p
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.p.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.p.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.p.? no%param) (nClip (Sub (vstd!arithmetic.power2.pow2.?
        (I 255)
       ) 19
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.p.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!) (EucMod (%I n!) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 51)) (%I (vstd!seq.Seq.index.? $ (UINT
                  64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
            )))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 102)) (%I (vstd!seq.Seq.index.? $ (UINT
                64
               ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
          )))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 153)) (%I (vstd!seq.Seq.index.? $ (UINT
              64
             ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
        )))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 204)) (%I (vstd!seq.Seq.index.? $ (UINT
            64
           ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 4)
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_x
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_x.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_y
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_y.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_y.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_z
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_z.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_t
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_t.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_t.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (tuple%4./tuple%4 (I x$) (I y$) (I z$) (I t$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
      (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (%I a!)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? b! (I (EucMod
         (%I a!) (%I b!)
        )
       ) fuel%
   ))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!) (
       curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b! (
        succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
    ))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
      b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
     b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a!
      b! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
      a! b! (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       (%I a!) (%I (I 1)) (%I (I 0))
      )
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
          b! (I (EucMod (%I a!) (%I b!))) fuel%
       )))
       (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
        (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (Sub (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (Mul (EucDiv (%I a!) (%I b!)) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
             (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
               r$
   ))))))))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
       a! b!
      ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
      a! b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.? a!
       b!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
     a! b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! fuel%
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 (Poly Poly) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%18
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%19
      (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
          (%I a!) (%I m!)
         )
        ) m!
       ) 1
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
  (forall ((a! Poly) (m! Poly)) (!
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
      m!
     ) (ite
      (or
       (<= (%I m!) 1)
       (not (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
            (%I a!) (%I m!)
           )
          ) m!
         ) 1
      )))
      0
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
          (I (EucMod (%I a!) (%I m!))) m!
       )))
       (nClip (EucMod (Add (EucMod (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (%I m!)
          ) (%I m!)
         ) (%I m!)
    )))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
))))
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type m! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
     a! m!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_inv
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_inv.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_inv.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_inv.? a!) (ite
      (= (EucMod (%I a!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
      0
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
       (I (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
    )))
    :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_inv.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_mul.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_mul.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_mul.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z_inv$)))
            (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z_inv$)))
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::u64_5_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
  (forall ((limbs! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!) (forall (
       (i$ Poly)
      ) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) limbs!
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I (%I bit_limit!))))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) limbs!
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_38
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_38
    )))
    :pattern ((curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
  (forall ((fe! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!) (curve25519_dalek!specs.field_specs.u64_5_bounded.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )
      ) bit_limit!
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_neg.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_neg.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          a!
    ))))))
    :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_neg.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::mask51
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
  (= curve25519_dalek!specs.field_specs_u64.mask51.? 2251799813685247)
))
(assert
 (uInv 64 curve25519_dalek!specs.field_specs_u64.mask51.?)
)

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_reduce
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
)
(declare-fun %%array%%0 (Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   )
  ) (!
   (let
    ((%%x%% (%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
   ))
   :pattern ((%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (uClip 64 (bitand
                (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                     (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (Mul (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 4)
                  ))
                 ) (I 51)
                )
               ) 19
            )))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 1)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 2)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 1)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 3)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 2)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 4)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 3)
                 ))
                ) (I 51)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
  (= curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? (%Poly%array%. (array_new
     $ (UINT 64) 5 (%%array%%0 (I 36028797018963664) (I 36028797018963952) (I 36028797018963952)
      (I 36028797018963952) (I 36028797018963952)
))))))
(assert
 (has_type (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?) (ARRAY
   $ (UINT 64) $ (CONST_INT 5)
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.?
                $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                  curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?
                 )
                ) (I 0)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 1)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 2)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 3)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 4)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 4)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_negate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!) (let
      ((r$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?
           limbs!
      )))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::negate_affine_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.negate_affine_niels.)
  (forall ((p! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.negate_affine_niels.? p!) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
         (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
                 (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. p!)
    )))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.negate_affine_niels.? p!))
    :qid internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_definition
))))
(assert
 (forall ((p! Poly)) (!
   (=>
    (has_type p! TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!specs.edwards_specs.negate_affine_niels.?
       p!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.negate_affine_niels.? p!))
   :qid internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_affine_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::negate_projective_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.)
  (forall ((p! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
    )))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!))
    :qid internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_definition
))))
(assert
 (forall ((p! Poly)) (!
   (=>
    (has_type p! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!)
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!))
   :qid internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
  (= curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 929955233495203) (I 466365720129213)
       (I 1662059464998953) (I 2033849074728123) (I 1442794654840575)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_square
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_square.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_square.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_square.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I a!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_square.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_sub.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_sub.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (nClip (Add (curve25519_dalek!specs.field_specs_u64.field_canonical.? a!)
           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )
         ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? b!)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_add.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_add.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Add (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_add.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
  (forall ((x! Poly) (y! Poly) (z! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
     (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
       (let
        ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
        (let
         ((z2$ (curve25519_dalek!specs.field_specs.field_square.? z!)))
         (let
          ((z4$ (curve25519_dalek!specs.field_specs.field_square.? (I z2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                (I y2$) (I x2$)
               )
              ) (I z2$)
           )))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I z4$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$)))
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x!
      y! z!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
  (forall ((x! Poly) (y! Poly) (z! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x! y! z!
      t!
     ) (and
      (and
       (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? z!) 0))
       (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
      )
      (= (curve25519_dalek!specs.field_specs.field_mul.? x! y!) (curve25519_dalek!specs.field_specs.field_mul.?
        z! t!
    ))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x!
      y! z! t!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x$) (I y$)
          (I z$) (I t$)
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!) (and
      (and
       (and
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
         ) (I 52)
        )
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
         ) (I 52)
       ))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ) (I 52)
      ))
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
       ) (I 52)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
  (forall ((fe1! Poly) (fe2! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!) (forall
      ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
              ))
             ) i$
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
              ))
             ) i$
           ))
          ) (%I bound!)
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
          ))
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
          ))
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_39
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_39
    )))
    :pattern ((curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!))
    :qid internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!) (and
      (and
       (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!)
       (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!)
      )
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
         point!
        )
       ) (I 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_identity
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param) (tuple%2./tuple%2
      (I 0) (I 1)
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
  (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!) (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x1x2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! x2!)))
       (let
        ((y1y2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! y2!)))
        (let
         ((x1y2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! y2!)))
         (let
          ((y1x2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! x2!)))
          (let
           ((t$ (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I x1x2$) (I y1y2$)
           )))))
           (let
            ((denom_x$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t$))))
            (let
             ((denom_y$ (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t$))))
             (let
              ((x3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                   (I x1y2$) (I y1x2$)
                  )
                 ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_x$)))
              )))
              (let
               ((y3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                    (I y1y2$) (I x1x2$)
                   )
                  ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_y$)))
               )))
               (tuple%2./tuple%2 (I x3$) (I y3$))
    )))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
))))
(assert
 (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
   (=>
    (and
     (has_type x1! NAT)
     (has_type y1! NAT)
     (has_type x2! NAT)
     (has_type y2! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1!
       x2! y2!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_double
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
      x! y! x! y!
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
)
(declare-const fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. Fuel)
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     fuel%
    ) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     zero
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
      (succ fuel%)
     ) (ite
      (= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (ite
       (= (%I n!) 1)
       (%Poly%tuple%2. point_affine!)
       (ite
        (= (EucMod (%I n!) 2) 0)
        (let
         ((half$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (EucDiv (%I n!) 2)) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. half$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. half$)))
        ))
        (let
         ((prev$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (nClip (Sub (%I n!) 1))) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. prev$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. point_affine!)
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point_affine!))
   )))))))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
      (has_type n! NAT)
     )
     (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! n!) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! (succ fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
)))

;; Function-Axioms vstd::view::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%0.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (REF A&.) A& self!) (vstd!view.View.view.? A&. A& self!))
    )
    :pattern ((vstd!view.View.view.? (REF A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%2::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%2.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%2.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%4::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%4.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%4.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%6::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%6.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%6.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%12::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%12.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%12.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ TYPE%tuple%0. self!) self!)
    :pattern ((vstd!view.View.view.? $ TYPE%tuple%0. self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%14::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%14.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%14.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ BOOL self!) self!)
    :pattern ((vstd!view.View.view.? $ BOOL self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%22::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%22.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%22.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 64) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 64) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%26::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%26.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%26.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ USIZE self!) self!)
    :pattern ((vstd!view.View.view.? $ USIZE self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%32::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%32.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%32.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%44::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%44.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%44.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
     )
     (= (vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!) (Poly%tuple%2.
       (tuple%2./tuple%2 (vstd!view.View.view.? A0&. A0& (tuple%2./tuple%2/0 (%Poly%tuple%2.
           self!
         ))
        ) (vstd!view.View.view.? A1&. A1& (tuple%2./tuple%2/1 (%Poly%tuple%2. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%46::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%46.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%46.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (self! Poly))
   (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
     )
     (= (vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&) self!)
      (Poly%tuple%3. (tuple%3./tuple%3 (vstd!view.View.view.? A0&. A0& (tuple%3./tuple%3/0
          (%Poly%tuple%3. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%3./tuple%3/1 (%Poly%tuple%3. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%3./tuple%3/2 (%Poly%tuple%3. self!))
    )))))
    :pattern ((vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)
      self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%48::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%48.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%48.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
    (A3& Type) (self! Poly)
   ) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (sized A3&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
      (tr_bound%vstd!view.View. A3&. A3&)
     )
     (= (vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
        A3&
       ) self!
      ) (Poly%tuple%4. (tuple%4./tuple%4 (vstd!view.View.view.? A0&. A0& (tuple%4./tuple%4/0
          (%Poly%tuple%4. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%4./tuple%4/1 (%Poly%tuple%4. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%4./tuple%4/2 (%Poly%tuple%4. self!))
        ) (vstd!view.View.view.? A3&. A3& (tuple%4./tuple%4/3 (%Poly%tuple%4. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
       A3&. A3&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::negate_lemmas::all_neg_limbs_positive
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.? limbs!)
     (and
      (and
       (and
        (and
         (>= 36028797018963664 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
             (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
            ) (I 0)
         )))
         (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
             (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
            ) (I 1)
        ))))
        (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
           ) (I 2)
       ))))
       (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
           (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
          ) (I 3)
      ))))
      (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
          (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
         ) (I 4)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?
      limbs!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul_signed
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
      n!
     ) (ite
      (>= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! (I (nClip (
          %I n!
      ))))
      (let
       ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! (I
           (nClip (Sub 0 (%I n!)))
       ))))
       (let
        ((x$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((y$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
         (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_neg.? (I x$))) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
     ) (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
       )))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
        )))))
        (let
         ((x_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (let
          ((y_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
               (I y_plus_x$) (I y_minus_x$)
              )
             ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
          )))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (let
            ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
            (let
             ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
             (tuple%2./tuple%2 (I x$) (I y$))
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
            )))))
            (let
             ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                  (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
             )))))
             (let
              ((niels_z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
                   (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
              )))))
              (let
               ((t2d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                    (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
               )))))
               (and
                (and
                 (and
                  (= y_plus_x$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                  (= y_minus_x$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                 )
                 (= niels_z$ z$)
                )
                (= t2d$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                    (I 2) (I d$)
                   )
                  ) (I t$)
    ))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!)
     (exists ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
          (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
         )
         (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_40
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_40
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::affine_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? niels!
      point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x_proj$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_proj$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_proj$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z_proj$))))
            (let
             ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
             (let
              ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
              (let
               ((y_plus_x_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
                    (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
               )))))
               (let
                ((y_minus_x_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                    (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
                     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
                )))))
                (let
                 ((xy2d_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                     (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
                      (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
                 )))))
                 (and
                  (and
                   (= y_plus_x_niels$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                   (= y_minus_x_niels$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                  )
                  (= xy2d_niels$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                      (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I y$))) (I 2)
                     )
                    ) (I d$)
    ))))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_affine_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? niels!) (exists
      ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
           (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
          )
          (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_y.? point$)
           ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
             point$
            )
           ) (I 18446744073709551615)
         ))
         (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_affine_niels_point_41
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_affine_niels_point_41
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::affine_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? niels!)
     (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
           (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
            (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
       )))))
       (let
        ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
             (I y_plus_x$) (I y_minus_x$)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
        )))
        (let
         ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (tuple%2./tuple%2 (I x$) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!) (let
      ((p$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (let
       ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
       ))))
       (let
        ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
        (let
         ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
         (let
          ((x2y2$ (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_sub.? (I y2$) (I x2$))))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I x2y2$)
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_point_edwards_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)
     (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
            %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. point!
      ))))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y (
             %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. point!
       ))))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z (
              %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. point!
        ))))))
        (tuple%3./tuple%3 (I x$) (I y$) (I z$))
    ))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%tuple%3. (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?
       point!
      )
     ) (TYPE%tuple%3. $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_projective_point_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? no%param)
     (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
         (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0))))
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
      no%param
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
       no%param
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
     no%param
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.? point!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((y$ (%I (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((z$ (%I (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (let
          ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
          (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z_inv$)))
           (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z_inv$)))
    )))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
      point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
     point!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_affine_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!specs.edwards_specs.identity_affine_niels.?
       no%param
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_projective_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param)
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_neg.? point!) (tuple%2./tuple%2 (I
       (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          point!
       )))
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point!))
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! (TYPE%tuple%2. $ NAT $ NAT))
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_projective_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((y$ (%I (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((z$ (%I (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (and
          (not (= z$ 0))
          (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? (I x$) (I y$)
           (I z$)
    )))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::primality_specs::is_prime
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.primality_specs.is_prime.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.primality_specs.is_prime.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.primality_specs.is_prime.? n!) (and
      (> (%I n!) 1)
      (forall ((d$ Int)) (!
        (=>
         (<= 0 d$)
         (=>
          (let
           ((tmp%%$ d$))
           (and
            (< 1 tmp%%$)
            (< tmp%%$ (%I n!))
          ))
          (not (= (EucMod (%I n!) d$) 0))
        ))
        :pattern ((EucMod (%I n!) d$))
        :qid user_curve25519_dalek__specs__primality_specs__is_prime_42
        :skolemid skolem_user_curve25519_dalek__specs__primality_specs__is_prime_42
    ))))
    :pattern ((curve25519_dalek!specs.primality_specs.is_prime.? n!))
    :qid internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (REF A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (REF A&.) A&))
   :qid internal_vstd__view__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__6_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
    )
    (tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_vstd__view__impl&__44_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
    )
    (tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_vstd__view__impl&__46_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (sized A3&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
     (tr_bound%vstd!view.View. A3&. A3&)
    )
    (tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
   )))
   :pattern ((tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_vstd__view__impl&__48_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__48_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_even
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even.
 (Int) Bool
)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!) (=>
     %%global_location_label%%20
     (>= n! 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!) (= (EucMod
      (vstd!arithmetic.power2.pow2.? (I n!)) 2
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_MUL_div
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. (Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k! s!) (
     =>
     %%global_location_label%%21
     (>= k! s!)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k!
     s!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k! s!) (
     = (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
       (I s!)
      )
     ) (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub k! s!))))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k!
     s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs_u64::p_gt_2
(declare-fun ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. no%param) (and
     (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2)
     (> (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2) 0)
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs_u64.p_gt_2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs_u64.p_gt_2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_fe51_limbs_bounded_weaken
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! Int) (
    b! Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
    ) (and
     (=>
      %%global_location_label%%22
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       ) (I a!)
     ))
     (=>
      %%global_location_label%%23
      (< a! b!)
     )
     (=>
      %%global_location_label%%24
      (<= b! 63)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int Int) Bool
)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! Int) (
    b! Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
    ) (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      fe!
     ) (I b!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
)))

;; Function-Specs curve25519_dalek::specs::primality_specs::axiom_p_is_prime
(declare-fun ens%curve25519_dalek!specs.primality_specs.axiom_p_is_prime. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.primality_specs.axiom_p_is_prime. no%param) (curve25519_dalek!specs.primality_specs.is_prime.?
     (I (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!specs.primality_specs.axiom_p_is_prime. no%param))
   :qid internal_ens__curve25519_dalek!specs.primality_specs.axiom_p_is_prime._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.primality_specs.axiom_p_is_prime._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs::field_inv_property
(declare-fun req%curve25519_dalek!specs.field_specs.field_inv_property. (Int) Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!specs.field_specs.field_inv_property. a!) (=>
     %%global_location_label%%25
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!specs.field_specs.field_inv_property. a!))
   :qid internal_req__curve25519_dalek!specs.field_specs.field_inv_property._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.field_specs.field_inv_property._definition
)))
(declare-fun ens%curve25519_dalek!specs.field_specs.field_inv_property. (Int) Bool)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs.field_inv_property. a!) (and
     (< (curve25519_dalek!specs.field_specs.field_inv.? (I a!)) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
     ))
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs_u64.field_canonical.?
         (I a!)
        )
       ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I a!)))
      ) 1
   )))
   :pattern ((ens%curve25519_dalek!specs.field_specs.field_inv_property. a!))
   :qid internal_ens__curve25519_dalek!specs.field_specs.field_inv_property._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs.field_inv_property._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_inv_one
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one.
     no%param
    ) (= (curve25519_dalek!specs.field_specs.field_inv.? (I 1)) 1)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_one_right
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I 1)) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_zero_left
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
 (Int Int) Bool
)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (=>
     %%global_location_label%%26
     (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_inv_mul_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
 (Int) Bool
)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
    ) (=>
     %%global_location_label%%27
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I a!)
       )
      ) (I a!)
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_assoc
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
       )
      ) (I c!)
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I b!) (I c!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_neg_square_eq
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I x!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_square_mod_noop
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_square.? (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
      )))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I x!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_self
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I x!) (I x!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_eq_add_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_add.?
      (I a!) (I (curve25519_dalek!specs.field_specs.field_neg.? (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_euclid_prime
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((a! Int) (b! Int) (p! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
    ) (and
     (=>
      %%global_location_label%%28
      (curve25519_dalek!specs.primality_specs.is_prime.? (I p!))
     )
     (=>
      %%global_location_label%%29
      (= (EucMod (nClip (Mul a! b!)) p!) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (p! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
    ) (or
     (= (EucMod a! p!) 0)
     (= (EucMod b! p!) 0)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_zero_right
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
 (Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
    ) (=>
     %%global_location_label%%30
     (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_comm
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_mul.?
      (I b!) (I a!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_on_curve
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_on_curve.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_on_curve.
     no%param
    ) (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I 0) (I 1))
   )
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_on_curve.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_on_curve._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_on_curve._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_element_reduced
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
 (Int) Bool
)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((x! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
    ) (=>
     %%global_location_label%%31
     (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
    ) (= (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) x!)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_affine_to_extended_valid
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((x! Int) (y! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid.
     x! y! t!
    ) (and
     (=>
      %%global_location_label%%32
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x!) (I y!))
     )
     (=>
      %%global_location_label%%33
      (= t! (curve25519_dalek!specs.field_specs.field_mul.? (I x!) (I y!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid.
     x! y! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid.
     x! y! t!
    ) (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x!) (
      I y!
     ) (I 1) (I t!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid.
     x! y! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_to_extended_valid._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_is_valid_extended
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_is_valid_extended.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_is_valid_extended.
     no%param
    ) (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I 0) (I
      1
     ) (I 1) (I 0)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_is_valid_extended.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_is_valid_extended._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_is_valid_extended._definition
)))

;; Function-Specs curve25519_dalek::specs::edwards_specs::lemma_unfold_edwards
(declare-fun ens%curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards. (curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((point! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (ens%curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards. point!) (and
     (= (curve25519_dalek!specs.edwards_specs.edwards_x.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_y.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_z.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_t.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
       )
      ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
        (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
   )))))
   :pattern ((ens%curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards. point!))
   :qid internal_ens__curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.edwards_specs.lemma_unfold_edwards._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_inv_of_product
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I a!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_cancel_common_factor
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%34
      (not (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%35
      (not (= (EucMod c! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_mul.?
          (I b!) (I c!)
      ))))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_nonzero_product
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
 (Int Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
    ) (and
     (=>
      %%global_location_label%%36
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%37
      (not (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
    ) (not (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) 0))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_quotient_of_squares
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I a!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I b!)
      ))))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I b!)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_distributes_over_add
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_add.?
        (I b!) (I c!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I c!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg.
 (Int Int) Bool
)
(assert
 (forall ((c! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg.
     c! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I c!) (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I b!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I c!) (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg.
     c! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_distributes_over_sub_right
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I a!) (I b!)
       )
      ) (I c!)
     ) (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I b!) (I c!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_one_left
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I 1) (I a!)) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_valid_extended_point_affine_on_curve
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve.
     x! y! z! t!
    ) (=>
     %%global_location_label%%38
     (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x!) (I y!)
      (I z!) (I t!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve.
     x! y! z! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve.
     x! y! z! t!
    ) (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
       (I x!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z!)))
      )
     ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
         (I z!)
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve.
     x! y! z! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_valid_extended_point_affine_on_curve._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_sub_recover_double
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_recover_double.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_recover_double.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_add.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!)))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I b!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_recover_double.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_recover_double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_recover_double._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_add_recover_double
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_add_recover_double.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_add_recover_double.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_add.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!)))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I a!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_add_recover_double.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_add_recover_double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_add_recover_double._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_left_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%39
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%40
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
    ) (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod c! (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_comm
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_add.?
      (I b!) (I a!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::axiom_edwards_add_complete
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete.
     x1! y1! x2! y2!
    ) (and
     (=>
      %%global_location_label%%41
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x1!) (I y1!))
     )
     (=>
      %%global_location_label%%42
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x2!) (I y2!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete.
     x1! y1! x2! y2!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete.
     x1! y1! x2! y2!
    ) (and
     (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((t$ (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.?
            (I (curve25519_dalek!specs.field_specs.field_mul.? (I x1!) (I x2!))) (I (curve25519_dalek!specs.field_specs.field_mul.?
              (I y1!) (I y2!)
       )))))))
       (and
        (not (= (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t$)) 0))
        (not (= (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t$)) 0))
     )))
     (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
        (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!)
          (I x2!) (I y2!)
       )))
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
          (I x1!) (I y1!) (I x2!) (I y2!)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete.
     x1! y1! x2! y2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_complete._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_completed_point_ratios
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios.
 (Int Int Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int) (result_x! Int) (result_y! Int) (result_z!
    Int
   ) (result_t! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios.
     x1! y1! x2! y2! result_x! result_y! result_z! result_t!
    ) (and
     (=>
      %%global_location_label%%43
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x1!) (I y1!))
     )
     (=>
      %%global_location_label%%44
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x2!) (I y2!))
     )
     (=>
      %%global_location_label%%45
      (= result_x! (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_add.?
          (I (curve25519_dalek!specs.field_specs.field_mul.? (I x1!) (I y2!))) (I (curve25519_dalek!specs.field_specs.field_mul.?
            (I y1!) (I x2!)
     )))))))
     (=>
      %%global_location_label%%46
      (= result_y! (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_add.?
          (I (curve25519_dalek!specs.field_specs.field_mul.? (I y1!) (I y2!))) (I (curve25519_dalek!specs.field_specs.field_mul.?
            (I x1!) (I x2!)
     )))))))
     (=>
      %%global_location_label%%47
      (= result_z! (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_add.?
          (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
              (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I x1!) (I x2!)
               )
              ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y1!) (I y2!)))
     )))))))))
     (=>
      %%global_location_label%%48
      (= result_t! (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_sub.?
          (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
              (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I x1!) (I x2!)
               )
              ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y1!) (I y2!)))
   )))))))))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios.
     x1! y1! x2! y2! result_x! result_y! result_z! result_t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios.
 (Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int) (result_x! Int) (result_y! Int) (result_z!
    Int
   ) (result_t! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios.
     x1! y1! x2! y2! result_x! result_y! result_z! result_t!
    ) (and
     (not (= result_z! 0))
     (not (= result_t! 0))
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I result_x!) (I (curve25519_dalek!specs.field_specs.field_inv.?
         (I result_z!)
       ))
      ) (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
           (I x1!) (I y1!) (I x2!) (I y2!)
     ))))))
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I result_y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
         (I result_t!)
       ))
      ) (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
           (I x1!) (I y1!) (I x2!) (I y2!)
     ))))))
     (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I result_x!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I result_z!)))
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I result_y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I result_t!)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios.
     x1! y1! x2! y2! result_x! result_y! result_z! result_t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_completed_point_ratios._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_halve_double
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_halve_double.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_halve_double.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I 2) (I a!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
     ) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_halve_double.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_halve_double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_halve_double._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_recover_xy_from_niels_encoding
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((y_plus_x! Int) (y_minus_x! Int) (x! Int) (y! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding.
     y_plus_x! y_minus_x! x! y!
    ) (and
     (=>
      %%global_location_label%%49
      (= y_plus_x! (curve25519_dalek!specs.field_specs.field_add.? (I y!) (I x!)))
     )
     (=>
      %%global_location_label%%50
      (= y_minus_x! (curve25519_dalek!specs.field_specs.field_sub.? (I y!) (I x!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding.
     y_plus_x! y_minus_x! x! y!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding.
 (Int Int Int Int) Bool
)
(assert
 (forall ((y_plus_x! Int) (y_minus_x! Int) (x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding.
     y_plus_x! y_minus_x! x! y!
    ) (and
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
         (I y_plus_x!) (I y_minus_x!)
        )
       ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
      ) (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
         (I y_plus_x!) (I y_minus_x!)
        )
       ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
      ) (EucMod y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding.
     y_plus_x! y_minus_x! x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_recover_xy_from_niels_encoding._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_projective_niels_affine_equals_edwards_affine
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((niels! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (point! curve25519_dalek!edwards.EdwardsPoint.)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
    ) (and
     (=>
      %%global_location_label%%51
      (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        niels!
       ) (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
     ))
     (=>
      %%global_location_label%%52
      (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        point!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((niels! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (point! curve25519_dalek!edwards.EdwardsPoint.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
    ) (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       point!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine.
     niels! point!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_niels_affine_equals_edwards_affine._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_affine_curve_implies_projective
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective.
     x! y! z!
    ) (and
     (=>
      %%global_location_label%%53
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%54
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
         (I x!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z!)))
        )
       ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
           (I z!)
   ))))))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective.
     x! y! z!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective.
     x! y! z!
    ) (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? (I x!) (I
      y!
     ) (I z!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective.
     x! y! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_affine_curve_implies_projective._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_neg_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I a!)
      ))
     ) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_sub_neg_eq_add
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add.
 (Int Int) Bool
)
(assert
 (forall ((c! Int) (d! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add.
     c! d!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I c!) (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I d!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_add.? (I c!) (I d!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add.
     c! d!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_negation_preserves_curve
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve.
 (Int Int) Bool
)
(declare-const %%global_location_label%%55 Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve.
     x! y!
    ) (=>
     %%global_location_label%%55
     (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x!) (I y!))
   ))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve.
     x! y!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve.
     x! y!
    ) (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_neg.?
       (I x!)
      )
     ) (I y!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_curve._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::negate_lemmas::lemma_neg_no_underflow
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
    ) (=>
     %%global_location_label%%56
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 54)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. limbs!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__lemma_neg_no_underflow_115
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__lemma_neg_no_underflow_115
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
    ) (curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.? (Poly%array%.
      limbs!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::negate_lemmas::proof_negate
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%57 Bool)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!) (
     and
     (=>
      %%global_location_label%%57
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 5)
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 54)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_116
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_116
     )))
     (=>
      %%global_location_label%%58
      (curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.? (Poly%array%.
        limbs!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!) (
     and
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%.
                limbs!
             )))
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%.
             limbs!
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_117
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_117
     ))
     (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.?
         (Poly%array%. limbs!)
       ))
      ) (Sub (Sub (nClip (Mul 16 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
         (Poly%array%. limbs!)
        )
       ) (Mul (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (uClip 64 (bitshr (I (uClip
            64 (Sub 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
               ) (I 4)
           ))))
          ) (I 51)
     )))))
     (= (EucMod (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
           (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. limbs!))
          )
         ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::negate_lemmas::lemma_neg
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%59 Bool)
(assert
 (forall ((elem! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!) (=>
     %%global_location_label%%59
     (= (EucMod (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
           (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                elem!
          ))))))
         ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              elem!
        ))))))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) 0
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((elem! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!) (= (EucMod
      (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.?
         (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             elem!
       ))))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
        (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. elem!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_negation_preserves_extended_validity
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%60 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity.
     x! y! z! t!
    ) (=>
     %%global_location_label%%60
     (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x!) (I y!)
      (I z!) (I t!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity.
     x! y! z! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity.
     x! y! z! t!
    ) (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I (curve25519_dalek!specs.field_specs.field_neg.?
       (I x!)
      )
     ) (I y!) (I z!) (I (curve25519_dalek!specs.field_specs.field_neg.? (I t!)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity.
     x! y! z! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negation_preserves_extended_validity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_commutative
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
     x1! y1! x2! y2!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
       y2!
      )
     ) (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x2!) (I y2!) (I x1!) (I y1!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
     x1! y1! x2! y2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::axiom_edwards_add_associative
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
 (Int Int Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int) (x3! Int) (y3! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
     x1! y1! x2! y2! x3! y3!
    ) (= (let
      ((ab$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
          y2!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. ab$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. ab$))) (I x3!) (I y3!)
      )
     ) (let
      ((bc$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x2!) (I y2!) (I x3!) (I
          y3!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. bc$))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. bc$)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
     x1! y1! x2! y2! x3! y3!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_double_of_add
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_of_add.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_of_add.
     x1! y1! x2! y2!
    ) (= (let
      ((ab$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
          y2!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. ab$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. ab$)))
      )
     ) (let
      ((aa$ (curve25519_dalek!specs.edwards_specs.edwards_double.? (I x1!) (I y1!))))
      (let
       ((bb$ (curve25519_dalek!specs.edwards_specs.edwards_double.? (I x2!) (I y2!))))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. aa$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. aa$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. bb$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. bb$)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_of_add.
     x1! y1! x2! y2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_of_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_of_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_succ
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
 (tuple%2. Int) Bool
)
(declare-const %%global_location_label%%61 Bool)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
    ) (=>
     %%global_location_label%%61
     (>= n! 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
 (tuple%2. Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (nClip (Add n! 1)))
     ) (let
      ((prev$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
         (I n!)
      )))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. prev$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. point_affine!))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::u64_5_as_nat_lemmas::lemma_fe51_unit_is_one
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one.
     fe!
    ) (and
     (=>
      %%global_location_label%%62
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
          ))))
         ) (I 0)
        )
       ) 1
     ))
     (=>
      %%global_location_label%%63
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
          ))))
         ) (I 1)
        )
       ) 0
     ))
     (=>
      %%global_location_label%%64
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
          ))))
         ) (I 2)
        )
       ) 0
     ))
     (=>
      %%global_location_label%%65
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
          ))))
         ) (I 3)
        )
       ) 0
     ))
     (=>
      %%global_location_label%%66
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
          ))))
         ) (I 4)
        )
       ) 0
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one.
     fe!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one.
     fe!
    ) (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       fe!
      )
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one.
     fe!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_fe51_unit_is_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_projective_niels_valid
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid.
     no%param
    ) (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_valid._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_neg_mul_left
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I a!)
       )
      ) (I b!)
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_canonical_left
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_canonical_left.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_canonical_left.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
       ))
      ) (I b!)
     ) (curve25519_dalek!specs.field_specs.field_add.? (I a!) (I b!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_canonical_left.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_canonical_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_canonical_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_negate_projective_niels_preserves_validity
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Bool
)
(declare-const %%global_location_label%%67 Bool)
(declare-const %%global_location_label%%68 Bool)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(declare-const %%global_location_label%%71 Bool)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
    ) (and
     (=>
      %%global_location_label%%67
      (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        pt!
     )))
     (=>
      %%global_location_label%%68
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%69
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%70
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%71
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           pt!
        )))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Bool
)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
    ) (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        pt!
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity.
     pt!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_preserves_validity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_projective_niels_is_identity
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_is_identity.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_is_identity.
     no%param
    ) (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (curve25519_dalek!specs.edwards_specs.identity_projective_niels.?
        (I 0)
      ))
     ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_is_identity.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_is_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_niels_is_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_antisymmetric
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I b!) (I a!)) (curve25519_dalek!specs.field_specs.field_neg.?
      (I (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_swap_sub_negates_mul
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_swap_sub_negates_mul.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_swap_sub_negates_mul.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I b!) (I a!)
       )
      ) (I c!)
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!))) (I c!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_swap_sub_negates_mul.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_swap_sub_negates_mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_swap_sub_negates_mul._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_negate_projective_niels_is_edwards_neg
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_is_edwards_neg.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Bool
)
(assert
 (forall ((pt! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_is_edwards_neg.
     pt!
    ) (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (curve25519_dalek!specs.edwards_specs.negate_projective_niels.?
        (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. pt!)
      ))
     ) (curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
        (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. pt!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_is_edwards_neg.
     pt!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_is_edwards_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_negate_projective_niels_is_edwards_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_canonical
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_canonical.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_canonical.
     x1! y1! x2! y2!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
           (I x1!) (I y1!) (I x2!) (I y2!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
           (I x1!) (I y1!) (I x2!) (I y2!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_canonical.
     x1! y1! x2! y2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_canonical
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical.
 (tuple%2. Int) Bool
)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical.
     point_affine! n!
    ) (and
     (=>
      %%global_location_label%%72
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%73
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical.
     point_affine! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical.
 (tuple%2. Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical.
     point_affine! n!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
           (Poly%tuple%2. point_affine!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
           (Poly%tuple%2. point_affine!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical.
     point_affine! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_signed_canonical
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical.
 (tuple%2. Int) Bool
)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical.
     point_affine! n!
    ) (and
     (=>
      %%global_location_label%%74
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%75
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical.
     point_affine! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical.
 (tuple%2. Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical.
     point_affine! n!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
           (Poly%tuple%2. point_affine!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
           (Poly%tuple%2. point_affine!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical.
     point_affine! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_identity_right
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right.
     x! y!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x!) (I y!) (I 0) (I 1))
     (tuple%2./tuple%2 (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (I (EucMod y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_identity_left
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left.
     x! y!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (I 0) (I 1) (I x!) (I y!))
     (tuple%2./tuple%2 (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (I (EucMod y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_projective_implies_affine_on_curve
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
    ) (and
     (=>
      %%global_location_label%%76
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%77
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? (I x!) (I y!)
       (I z!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
    ) (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
       (I x!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z!)))
      )
     ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
         (I z!)
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_pow2_succ
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_pow2_succ.
 (tuple%2. Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_pow2_succ.
     point_affine! k!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (vstd!arithmetic.power2.pow2.? (I (nClip (Add k! 1)))))
     ) (let
      ((half$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
         (I (vstd!arithmetic.power2.pow2.? (I k!)))
      )))
      (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. half$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. half$)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_pow2_succ.
     point_affine! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_pow2_succ._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_pow2_succ._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_four_doublings_is_mul_16
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16.
 (tuple%2. tuple%2. tuple%2. tuple%2. tuple%2.) Bool
)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(declare-const %%global_location_label%%80 Bool)
(declare-const %%global_location_label%%81 Bool)
(assert
 (forall ((a0! tuple%2.) (a1! tuple%2.) (a2! tuple%2.) (a3! tuple%2.) (a4! tuple%2.))
  (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16.
     a0! a1! a2! a3! a4!
    ) (and
     (=>
      %%global_location_label%%78
      (= a1! (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. a0!)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. a0!)))
     )))
     (=>
      %%global_location_label%%79
      (= a2! (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. a1!)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. a1!)))
     )))
     (=>
      %%global_location_label%%80
      (= a3! (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. a2!)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. a2!)))
     )))
     (=>
      %%global_location_label%%81
      (= a4! (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. a3!)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. a3!)))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16.
     a0! a1! a2! a3! a4!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16.
 (tuple%2. tuple%2. tuple%2. tuple%2. tuple%2.) Bool
)
(assert
 (forall ((a0! tuple%2.) (a1! tuple%2.) (a2! tuple%2.) (a3! tuple%2.) (a4! tuple%2.))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16.
     a0! a1! a2! a3! a4!
    ) (= a4! (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. a0!)
      (I 16)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16.
     a0! a1! a2! a3! a4!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_four_doublings_is_mul_16._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_double_identity
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_identity.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_identity.
     no%param
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_double.? (I 0) (I 1)) (tuple%2./tuple%2
      (I 0) (I 1)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_identity.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_double_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_additive
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
 (tuple%2. Int Int) Bool
)
(declare-const %%global_location_label%%82 Bool)
(declare-const %%global_location_label%%83 Bool)
(assert
 (forall ((point_affine! tuple%2.) (m! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
    ) (and
     (=>
      %%global_location_label%%82
      (>= m! 1)
     )
     (=>
      %%global_location_label%%83
      (>= n! 1)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
 (tuple%2. Int Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (m! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
    ) (= (let
      ((pm$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
         (I m!)
      )))
      (let
       ((pn$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
          (I n!)
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. pm$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pm$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. pn$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pn$)))
      ))
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (nClip (Add m! n!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive.
     point_affine! m! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_additive._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_composition
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition.
 (tuple%2. Int Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition.
     point_affine! a! b!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
        (Poly%tuple%2. point_affine!) (I a!)
       )
      ) (I b!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (nClip (Mul a! b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition.
     point_affine! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_neg_distributes_over_add
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_distributes_over_add.
 (tuple%2. tuple%2.) Bool
)
(assert
 (forall ((P! tuple%2.) (Q! tuple%2.)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_distributes_over_add.
     P! Q!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
        (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly%tuple%2. P!)))
       )
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.?
          (Poly%tuple%2. P!)
       )))
      ) (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.?
          (Poly%tuple%2. Q!)
       )))
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.?
          (Poly%tuple%2. Q!)
      ))))
     ) (curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
        (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!))) (tuple%2./tuple%2/1 (%Poly%tuple%2.
          (Poly%tuple%2. P!)
         )
        ) (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. Q!))) (tuple%2./tuple%2/1 (%Poly%tuple%2.
          (Poly%tuple%2. Q!)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_distributes_over_add.
     P! Q!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_distributes_over_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_distributes_over_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_scalar_mul_distributes_over_neg
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
 (tuple%2. Int) Bool
)
(assert
 (forall ((P! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
     P! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.?
        (Poly%tuple%2. P!)
       )
      ) (I n!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
        (Poly%tuple%2. P!) (I n!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
     P! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_signed_composition
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
 (tuple%2. Int Int) Bool
)
(assert
 (forall ((P! tuple%2.) (a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
     P! a! b!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
        (Poly%tuple%2. P!) (I a!)
       )
      ) (I b!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       P!
      ) (I (Mul a! b!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
     P! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition._definition
)))

;; Function-Def curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_signed_composition
;; curve25519-dalek/src/lemmas/edwards_lemmas/curve_equation_lemmas.rs:1328:1: 1328:88 (#0)
(get-info :all-statistics)
(push)
 (declare-const P! tuple%2.)
 (declare-const a! Int)
 (declare-const b! Int)
 (declare-const an@ Int)
 (declare-const tmp%1 tuple%2.)
 (declare-const tmp%2 Int)
 (declare-const abs_a@ Int)
 (declare-const tmp%%@ tuple%2.)
 (declare-const x@ Int)
 (declare-const y@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%tuple%2. P!) (TYPE%tuple%2. $ NAT $ NAT))
 )
 (assert
  (<= 0 b!)
 )
 (declare-const %%switch_label%%0 Bool)
 (declare-const %%switch_label%%1 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; assertion failed
 (declare-const %%location_label%%5 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%6 Bool)
 (assert
  (not (=>
    (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
    (or
     (and
      (=>
       (>= a! 0)
       (=>
        (= an@ (nClip a!))
        (=>
         (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition.
          P! an@ b!
         )
         (and
          (and
           (=>
            %%location_label%%0
            (req%vstd!arithmetic.mul.lemma_mul_nonnegative. a! b!)
           )
           (=>
            (ens%vstd!arithmetic.mul.lemma_mul_nonnegative. a! b!)
            (=>
             %%location_label%%1
             (>= (Mul a! b!) 0)
          )))
          (=>
           (>= (Mul a! b!) 0)
           (and
            (=>
             (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. a! b!)
             (=>
              %%location_label%%2
              (= (nClip (Mul a! b!)) (nClip (Mul an@ b!)))
            ))
            (=>
             (= (nClip (Mul a! b!)) (nClip (Mul an@ b!)))
             %%switch_label%%0
      )))))))
      (=>
       (not (>= a! 0))
       (=>
        (= abs_a@ (nClip (Sub 0 a!)))
        (=>
         (= tmp%%@ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2.
            P!
           ) (I abs_a@)
         ))
         (=>
          (= x@ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%@)))))
          (=>
           (= y@ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%@)))))
           (=>
            (= tmp%1 (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. P!)
              (I abs_a@)
            ))
            (=>
             (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
              tmp%1 b!
             )
             (=>
              (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_composition.
               P! abs_a@ b!
              )
              (or
               (and
                (=>
                 (= b! 0)
                 (=>
                  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
                  (and
                   (=>
                    (ens%vstd!arithmetic.mul.lemma_mul_by_zero_is_zero. a!)
                    (=>
                     %%location_label%%3
                     (= (Mul a! b!) 0)
                   ))
                   (=>
                    (= (Mul a! b!) 0)
                    %%switch_label%%1
                ))))
                (=>
                 (not (= b! 0))
                 (and
                  (=>
                   (= tmp%2 (Sub 0 a!))
                   (=>
                    (ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. tmp%2 b!)
                    (=>
                     (ens%vstd!arithmetic.mul.lemma_mul_unary_negation. a! b!)
                     (=>
                      %%location_label%%4
                      (< (Mul a! b!) 0)
                  ))))
                  (=>
                   (< (Mul a! b!) 0)
                   (and
                    (=>
                     (ens%vstd!arithmetic.mul.lemma_mul_unary_negation. a! b!)
                     (=>
                      %%location_label%%5
                      (= (nClip (Sub 0 (Mul a! b!))) (nClip (Mul abs_a@ b!)))
                    ))
                    (=>
                     (= (nClip (Sub 0 (Mul a! b!))) (nClip (Mul abs_a@ b!)))
                     %%switch_label%%1
               ))))))
               (and
                (not %%switch_label%%1)
                %%switch_label%%0
     )))))))))))
     (and
      (not %%switch_label%%0)
      (=>
       %%location_label%%6
       (ext_eq false (TYPE%tuple%2. $ NAT $ NAT) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
          (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
             P!
            ) (I a!)
           )
          ) (I b!)
         )
        ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
          (Poly%tuple%2. P!) (I (Mul a! b!))
 )))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
